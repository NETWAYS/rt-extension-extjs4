package RT::Extension::Netways;

use 5.010_001;
use strict;
use warnings;

our $VERSION = '1.1.0';

RT->AddStyleSheets('netways.css');

=head1 NAME

RT-Extension-Netways - Changes on the RT system for the NETWAYS workflow

=head1 DESCRIPTION

Some special features for the NETWAYS GmbH.

https://www.netways.de

These features are the following:

=over

=item * Custom header for tickets [Configurable]

=item * Register ticket authors as AdminCc instead of Requestor [Configurable]

=item * Read-Only boxes under a ticket's basics to quickly copy and share details

=item * Quick removal of poeple registered as AdminCc or Requestor

=item * Quick assign of people as AdminCc or Owner [Configurable]

=item * Switched positions of ticket people and reminders

=item * Safety measures when merging tickets (aka A modal confirmation dialog)

=item * Empty search result boxes are automatically hidden (e.g. on "RT at a glance") [Configurable]

=item * Additional CSS classes for search result boxes (e.g. on "RT at a glance")

=over

=item netways-tickets-default (If no other of the following applies)

=item netways-tickets-request

=item netways-tickets-watched

=item netways-tickets-nobody

=item netways-tickets-due

=back

=back

=head1 RT VERSION

Works with RT 4.4.2

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::Netways');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 CONFIGURATION

=head2 C<$Netways_EnableTagFormat>

If enabled, applies the custom header for tickets.

=head2 C<$Netways_UserRequestorGroup>

The group of which authors must be a member to get registered as AdminCc instead of Requestor.

=head2 C<$Netways_EnableQuickAssign>

If enabled, shows the form controls to quickly assign people as AdminCc or Owner.

=head2 C<$Netways_QuickAssignGroup>

Which group's members should be choosable when showing the quick assign form controls.

=head2 C<$Netways_ShowSearchOnlyWithResults>

If enabled, hides empty search result boxes automatically. (e.g. on "RT at a glance")

=head2 Example

=over

=item C<# Enables everything provided by RT::Extension::Netways>

=item C<Set($Netways_EnableTagFormat, 1);>

=item C<Set($Netways_UserRequestorGroup, 'NETWAYS');>

=item C<Set($Netways_EnableQuickAssign, 1);>

=item C<Set($Netways_QuickAssignGroup, 'NETWAYS');>

=item C<Set($Netways_ShowSearchOnlyWithResults, 1);>

=back

=head1 AUTHOR

NETWAYS GmbH <lt>support@netways.de<gt>

=head1 BUGS

All bugs should be reported on L<Gitlab|https://git.netways.org/rt4/rt-extension-netways>.

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2018 by NETWAYS GmbH

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
