package RT::Action::SubjectAndEvent;

use strict;
use warnings;
use base qw(RT::Action);
use subs qw(
    Prepare
    Commit
);

sub MyTrim {
    my $str = shift;
    chomp($str);
    $str =~ s/^\s+|\s+$//g;
    return $str;
};

sub Prepare {
    my $self = shift;

    my $surname = undef;
    my $firstname = undef;
    my $package = undef;
    my $email = undef;
    my $event = undef;
    my $t = $self->TransactionObj;
    my $attachments = $t->Attachments;
    my $c = '';

    $RT::Logger->error('START Email and Name parser');

    while (my $attachment = $attachments->Next()) {
    if ($attachment->ContentType eq 'text/plain' && $attachment->Content  =~ m/email:\s*(.*?)$/m) {
        $c = $attachment->Content;
        last;
    }
    }

    unless ($c) {
    $RT::Logger->error('No suitable content found, abort!');
    }

    if ($c =~ m/firstname:\s*(.*?)$/m) {
    $firstname = MyTrim($1);
    }

    if ($c =~ m/lastname:\s*(.*?)$/m) {
    $surname = MyTrim($1);
    }

    if ($c =~ m/ticket(auswahl)?:\s*(Paket\s+)?([^\(\r\n]*)[^\r\n]*?$/m) {
    $package = MyTrim($3);
    }

    if ($c =~ m/email:\s*(.*?)$/m) {
    $email = MyTrim($1);
    }

    if ($c =~ m/EVENT:\s*(.*?)$/mi || $c =~ m/training:\s*(.*?)$/mi) {
    $event = MyTrim($1);
    }

    if ($firstname && $surname) {
        $self->TicketObj->SetSubject(
            sprintf(
                '%s (TN: %s %s%s)', $event, $firstname, $surname,
                $package ? sprintf(', Paket: %s', $package) : ''
            )
        );
    }

    if ($email) {
    $self->TicketObj->DeleteWatcher(
    Type => 'Requestor',
    PrincipalId => undef,
    Email => $self->TicketObj->RequestorAddresses()
    );

    $self->TicketObj->AddWatcher (
    Type => 'Requestor',
    PrincipalId => undef,
    Email => $email
    );
    }

    return 1;
}

sub Commit {
    return 1;
}

1;
