package RT::Action::SetOwner;

use 5.010_001;
use strict;
use warnings;
use base qw(RT::Action);
use subs qw(
    Prepare
    Commit
    UserArgument
);

our $VERSION='2.0.0';

sub Prepare {
    my $self = shift;
    RT->Logger->debug(__PACKAGE__. ': PREPARE');

    my $userid = $self->UserArgument();

    RT->Logger->debug(__PACKAGE__. ': Try to load user '. $userid);

    my $user = undef;

    if ($userid eq 'RT::Nobody') {
    	$user = RT->Nobody;
    } else {
        $user = RT::User->new(RT->SystemUser);
        $user->Load($userid);
    }

    if ($user && $user->Id > 0) {
        RT->Logger->error(__PACKAGE__. ': Got user: '. $user->Name);
        $self->{user} = $user;
        return 1;
    } else {
        RT->Logger->error(__PACKAGE__. ': Could not load valid user!');
        return;
    }
}

sub Commit {
    my $self = shift;

    if (ref($self->{user}) && $self->{user}->Id()) {
        $self->TicketObj->setOwner($self->{user}->Id(), 'Force');
    }
}

sub UserArgument {
    my $self = shift;

    my $userid = $self->TemplateObj->Content;

    unless ($userid) {
    	$userid = $self->Argument;
    }

    return $userid;
}

=head1 NAME

RT-Action-SetOwner - Scrip action to control the owner of a ticket

=head1 DESCRIPTION

Scrip action to control the owner of a ticket in two ways.

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

    Plugin('RT::Action::SetOwner');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 CONFIGURATION

Owner configured by template:

=over

=item 1. Create new template with name or id of the user,

=item 2. Create a new script use this action and select your new created template as template argument,

=item 3. Test and have fun!

=back

Owner by scrip argument:

=over

=item 1. Be a DB admin and connect to your RT database,

=item 2. Copy the row from Scrip table with the 'ExecModule' 'SetOwner' and add
         new 'Argument' value representing your user and place a new
         description,

=item 3. Create a new Scrip with your new ScriptAction created above,

=item 4. Test and have fun!

=back

Nobody user:

=over

=item 1. Create a new Scrip action with 'Set to nobody' action,

=item 2. Test and have fun!

=back

=head1 AUTHOR

NETWAYS GmbH <lt>support@netways.de<gt>

=head1 BUGS

All bugs should be reported on L<GitHub|https://github.com/NETWAYS/rt-extension-action-setowner>.

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2018 by NETWAYS GmbH

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
