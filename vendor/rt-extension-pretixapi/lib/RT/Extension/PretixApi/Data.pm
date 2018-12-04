package RT::Extension::PretixApi::Data;

use strict;
use warnings FATAL => 'all';

use RT;
use RT::Extension::PretixApi qw($BASE_URI $AUTH_TOKEN);
use Cache::FileCache;
use LWP::UserAgent;
use HTTP::Request;
use JSON::MaybeXS qw(decode_json);
use Storable qw(freeze thaw);

our $USER_AGENT = RT->Config->Get('Pretix_User_Agent')
    // RT->Config->Get('rtname') . '/' . $RT::Extension::PretixApi::VERSION;

our $TWITTER_QUESTION_ID = RT->Config->Get('Pretix_Twitter_QuestionId') // 'twitter';

our $CACHE_DISABLED = RT->Config->Get('Pretix_Cache_Disable') // 0;

our $CACHE_EXPIRATION = RT->Config->Get('Pretix_Cache_Expiration') // '60 minutes';

if ($CACHE_DISABLED) {
    RT->Logger->debug('Pretix: Cache disabled!');
} else {
    RT->Logger->debug(sprintf('Pretix: Cache enabled, expiration: %s', $CACHE_EXPIRATION));
}

sub new {
    my $classname = shift;
    my $org = lc(shift // '');

    my $type = ref $classname || $classname;

    unless (ref $AUTH_TOKEN eq 'HASH') {
        die('Pretix API Error: AUTH_TOKEN configuration must be a HASH');
    }

    unless (exists $AUTH_TOKEN->{$org}) {
        die("Pretix API Error: Org '$org' not found in AUTH_TOKEN");
    }

    RT->Logger->debug(sprintf('Pretix API, base="%s", org="%s", token="%s"', $BASE_URI, $org, $AUTH_TOKEN->{$org}));

    my $self = bless {
        BASE_URI   => $BASE_URI,
        AUTH_TOKEN => $AUTH_TOKEN->{$org}
    }, $type;


    $self->{'cache'} = Cache::FileCache->new({
        'namespace' => 'pretix',
        'directory_umask' => 077,
        'default_expires_in' => $CACHE_EXPIRATION
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

    my $request = HTTP::Request->new(GET => $self->{BASE_URI} . $uri);
    $request->header(Authorization => 'Token ' . $self->{AUTH_TOKEN});

    return $request;
}

sub has_sub_events {
    my $self = shift;
    my $organizers = shift;
    my $event = shift;

    my $ref = $self->get_event($organizers, $event);
    my $sub_flag = lc($ref->{'has_subevents'} // 'false');
    return 1 if ($sub_flag eq 'true');
    return 0;
}

sub get_sub_event {
    my $self = shift;
    my $organizers = shift;
    my $event = shift;
    my $subevent_id = shift;

    my $cache_key = 'event-' . join('-', $organizers, $event, $subevent_id);
    my $subevent = $self->{'cache'}->get($cache_key);

    if (defined $subevent && ! $CACHE_DISABLED) {
        return thaw $subevent;
    }

    my $uri = sprintf('/organizers/%s/events/%s/subevents/%d/', $organizers, $event, $subevent_id);
    my $req = $self->request($uri);

    my $res = $self->ua()->request($req);

    unless ($res->is_success) {
        RT->Logger->error(sprintf('Pretix API error: %s (%s)', $res->status_line, $uri));
        return undef;
    }

    my $ref = decode_json($res->content);
    $self->{'cache'}->set($cache_key, freeze $ref);
    return $ref;
}

sub get_event {
    my $self = shift;
    my $organizers = shift;
    my $event = shift;

    my $cache_key = 'event-' . join('-', $organizers, $event);
    my $event_ref = $self->{'cache'}->get($cache_key);

    if (defined $event_ref && ! $CACHE_DISABLED) {
        return thaw $event_ref;
    }

    my $uri = sprintf('/organizers/%s/events/%s', $organizers, $event);
    my $req = $self->request($uri);

    my $res = $self->ua()->request($req);

    unless ($res->is_success) {
        RT->Logger->error(sprintf('Pretix API error: %s (%s)', $res->status_line, $uri));
        return undef;
    }

    my $ref = decode_json($res->content);
    $self->{'cache'}->set($cache_key, freeze $ref);
    return $ref;
}

sub get_voucher {
    my $self = shift;
    my $organizers = shift;
    my $event = shift;
    my $voucher_id = shift;

    unless ($voucher_id && ! $CACHE_DISABLED) {
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

    if (defined $order && ! $CACHE_DISABLED) {
        return thaw $order;
    }

    my $uri = sprintf('/organizers/%s/events/%s/orders/%s', $organizers, $event, $order_code);
    my $req = $self->request($uri);

    my $res = $self->ua()->request($req);

    unless ($res->is_success) {
        RT->Logger->error(sprintf('Pretix API error: %s (%s)', $res->status_line, $uri));
        return undef;
    }

    my $event_ref = $self->get_event($organizers, $event);
    my $event_name = '';

    if (exists($event_ref->{'name'}->{'en'})) {
        $event_name = $event_ref->{'name'}->{'en'};
    } else {
        my @names = sort(values(%{ $event_ref->{'name'} }));
        $event_name = shift @names;
    }


    my $ref = decode_json($res->content);

    my $out = {
        'company'    => $ref->{'invoice_address'}->{'company'},
        'street'     => $ref->{'invoice_address'}->{'street'},
        'city'       => $ref->{'invoice_address'}->{'city'},
        'zip'        => $ref->{'invoice_address'}->{'zip'},
        'email'      => $ref->{'email'},
        'country'    => $ref->{'invoice_address'}->{'country'},
        'name'       => $ref->{'invoice_address'}->{'name'},
        'order'      => $order_code,
        'event'      => $event,
        'event_slug' => $event_ref->{'slug'},
        'event_name' => $event_name
    };

    my @positions;
    foreach my $position(@{ $ref->{'positions'} }) {

        my $position_append = {
            'name'    => $position->{'attendee_name'},
            'email'   => $position->{'attendee_email'},
            'voucher' => $self->get_voucher($organizers, $event, $position->{'voucher'}),
            'twitter' => ''
        };

        grep {
            $position_append->{'twitter'} = $_->{'answer'} if $_->{'question_identifier'} eq $TWITTER_QUESTION_ID
        } @{ $position->{'answers'} };

        if (exists($position->{'subevent'}) && $position->{'subevent'}) {
            my $sub_ref = $self->get_sub_event($organizers, $event, $position->{'subevent'});
            $position_append->{'date_from'} = $sub_ref->{'date_from'};
            $position_append->{'date_to'} = $sub_ref->{'date_to'};
        } else {
            $position_append->{'date_from'} = $event_ref->{'date_from'};
            $position_append->{'date_to'} = $event_ref->{'date_to'};
        }

        push @positions, $position_append;
    }

    $out->{'positions'} = \@positions;

    $self->{'cache'}->set($cache_key, freeze $out);

    return $out;

}


1;
