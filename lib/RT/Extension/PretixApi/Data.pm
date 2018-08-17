package RT::Extension::PretixApi::Data;

use strict;
use warnings FATAL => 'all';

use RT::Extension::PretixApi qw($BASE_URI $AUTH_TOKEN);
use RT;

use Cache::FileCache;
use LWP::UserAgent;
use HTTP::Request;
use JSON::MaybeXS qw(decode_json);
use Storable qw(freeze thaw);

our $USER_AGENT = RT->Config->Get('Pretix_User_Agent')
    // RT->Config->Get('rtname') . '/' . $RT::Extension::PretixApi::VERSION;

our $TWITTER_QUESTION_ID = RT->Config->Get('Pretix_Twitter_QuestionId') // 75;

sub new {
    my $classname = shift;
    my $type = ref $classname || $classname;


    my $self = bless {
        BASE_URI   => $BASE_URI,
        AUTH_TOKEN => $AUTH_TOKEN
    }, $type;

    $self->{'cache'} = Cache::FileCache->new({
        'namespace' => 'pretix',
        'directory_umask' => 077,
        'default_expires_in' => '60 minutes'
    });


    return $self;
}

sub ua {
    my $self = shift;

    my $ua = LWP::UserAgent->new();
    $ua->agent($USER_AGENT);

    return $ua;
}

sub request {
    my $self = shift;
    my $uri = shift;

    my $request = HTTP::Request->new(GET => $BASE_URI . $uri);
    $request->header(Authorization => 'Token ' . $AUTH_TOKEN);

    return $request;
}

sub has_sub_events {
    my $self = shift;
    my $organizers = shift;
    my $event = shift;

    my $ref = $self->get_event($organizers, $event);
    return sprintf('%d', $ref->{'has_subevents'}) // 0;
}

sub get_event {
    my $self = shift;
    my $organizers = shift;
    my $event = shift;

    my $cache_key = 'event-' . join('-', $organizers, $event);
    my $code = $self->{'cache'}->get($cache_key);

    if (defined $code) {
        return $code;
    }

    my $uri = sprintf('/organizers/%s/events/%s', $organizers, $event);
    my $req = $self->request($uri);

    my $res = $self->ua()->request($req);

    unless ($res->is_success) {
        RT->Logger->error(sprintf('Pretix API error: %s (%s)', $res->status_line, $uri));
        return undef;
    }

    my $ref = decode_json($res->content);
    $self->{'cache'}->set($cache_key, $ref->{'code'});
    return $ref;
}

sub get_voucher {
    my $self = shift;
    my $organizers = shift;
    my $event = shift;
    my $voucher_id = shift;

    unless ($voucher_id) {
        return '';
    }

    my $cache_key = 'voucher-' . join('-', $organizers, $event, $voucher_id);
    my $code = $self->{'cache'}->get($cache_key);

    if (defined $code) {
        return $code;
    }

    my $uri = sprintf('/organizers/%s/events/%s/vouchers/%d', $organizers, $event, $voucher_id);
    my $req = $self->request($uri);

    my $res = $self->ua()->request($req);

    unless ($res->is_success) {
        RT->Logger->error(sprintf('Pretix API error: %s (%s)', $res->status_line, $uri));
        return undef;
    }

    my $ref = decode_json($res->content);
    $self->{'cache'}->set($cache_key, $ref->{'code'});
    return $ref->{'code'} // '';
}

sub get_order {
    my $self = shift;
    my $organizers = shift;
    my $event = shift;
    my $order_code = shift;

    my $cache_key = 'order-' . join('-', $organizers, $event, $order_code);
    my $order = $self->{'cache'}->get($cache_key);

    if (defined $order) {
        return thaw $order;
    }

    my $uri = sprintf('/organizers/%s/events/%s/orders/%s', $organizers, $event, $order_code);
    my $req = $self->request($uri);

    my $res = $self->ua()->request($req);

    unless ($res->is_success) {
        RT->Logger->error(sprintf('Pretix API error: %s (%s)', $res->status_line, $uri));
        return undef;
    }

    my $ref = decode_json($res->content);

    my $out = {
        'company' => $ref->{'invoice_address'}->{'company'},
        'street'  => $ref->{'invoice_address'}->{'street'},
        'city'    => $ref->{'invoice_address'}->{'city'},
        'zip'     => $ref->{'invoice_address'}->{'zip'},
        'email'   => $ref->{'email'},
        'country' => $ref->{'invoice_address'}->{'country'},
        'name'    => $ref->{'invoice_address'}->{'name'},
        'order'   => $order_code,
        'event'   => $event
    };

    #use Data::Dumper;
    #print Dumper $ref;

    my @positions;

    foreach my $position(@{ $ref->{'positions'} }) {
        my $position_append = {
            'name'    => $position->{'attendee_name'},
            'email'   => $position->{'attendee_email'},
            'voucher' => $self->get_voucher($organizers, $event, $position->{'voucher'}),
            'twitter' => ''
        };

        grep {
            $position_append->{'twitter'} = $_->{'answer'} if $_->{'question'} eq $TWITTER_QUESTION_ID
        } @{ $position->{'answers'} };

        push @positions, $position_append;
    }

    $out->{'positions'} = \@positions;

    $self->{'cache'}->set($cache_key, freeze $out);

    return $out;

}


1;