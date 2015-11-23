package RT::Action::SubjectAndEvent;

use strict;
use warnings;
use base qw(RT::Action);
use subs qw(
    Prepare
    Commit
);

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
    $firstname = $1;
    chomp($firstname);
    }

    if ($c =~ m/lastname:\s*(.*?)$/m) {
    $surname = $1;
    chomp($surname);
    }

    if ($c =~ m/ticket(auswahl)?:\s*(Paket\s+)?([^\(\r\n]*)[^\r\n]*?$/m) {
    $package = $3;
    chomp($package);
    $package =~ s/^\s+|\s+$//g;
    }

    if ($c =~ m/email:\s*(.*?)$/m) {
    $email = $1;
    chomp($email);
    }

    if ($c =~ m/EVENT:\s*(.*?)$/m) {
    $event = $1;
    chomp($event);
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
