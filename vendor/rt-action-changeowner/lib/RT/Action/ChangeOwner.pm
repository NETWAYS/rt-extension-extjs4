package RT::Action::ChangeOwner;

use 5.010_001;
use strict;
use warnings;
use base qw(RT::Action);
use subs qw(
    Prepare
    Commit
);

our $VERSION='2.0.0';

sub Prepare {
    my $self = shift;
    RT->Logger->debug(__PACKAGE__. ": Prepare");
    RT->Logger->debug(__PACKAGE__. "::Argument: ". $self->Argument());

    # Do not apply on unowned tickets
    if ($self->TicketObj->OwnerObj->Id == RT->Nobody->Id) {
        return;
    }

    return 1;
}

sub Commit {
    my $self = shift;
    RT->Logger->debug(__PACKAGE__. ": Commit");
    RT->Logger->debug(__PACKAGE__. "::Argument: ". $self->Argument());

    if ($self->Argument =~ m/changeowner/) {

        RT->Logger->debug(__PACKAGE__. "::Commit Add owner as admincc");

        my $owner = $self->TicketObj->OwnerObj;
        $self->TicketObj->AddWatcher(
            Type => 'AdminCc',
            PrincipalId => $owner->PrincipalId
        );
    }

    if ($self->Argument =~ m/nobody/) {

        RT->Logger->debug(__PACKAGE__. "::Commit Set owner to Nobody");

        $self->TicketObj->SetOwner(RT->Nobody, 'Force');
    }
    return 1;
}

=head1 NAME

RT-Action-ChangeOwner

=head1 DESCRIPTION

This scrip action does the following: (Condition is ON RESOLVE)

=over

=item 1. Add the current owner to AdminCc

=item 2. Set the current owner to RT->Nobody

=back

This is intended if the customer replies to the ticket after a
couple of months. If the ticket owner is nobody everbody can own the ticket
to reply to the customer. The origin resolver / owner are also notified
to re-take or assist in case of problems.

=head1 RT VERSION

Works with RT 4.2

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Action::ChangeOwner');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 AUTHOR

NETWAYS GmbH <lt>support@netways.de<gt>

=head1 BUGS

All bugs should be reported on L<GitHub|https://github.com/NETWAYS/rt-action-changeowner>.

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2018 by NETWAYS GmbH

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
