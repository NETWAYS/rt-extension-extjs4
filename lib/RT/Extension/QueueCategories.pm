package RT::Extension::QueueCategories;

use strict;

use version;

our $VERSION="1.0.0";

=pod

=head1 NAME

RT::Extension::QueueCategories

=head1 DESCRIPTION

A simple extension that works with RT 4.4.2 which provides queues grouping
by categories.

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

    Plugin('RT::Extension::QueueCategories');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 CONFIGURATION

=over

=item Create a custom field "QueueCategory" of type "Select one value"

=item Add the desired categories as values

=item Apply it to all queues (globally)

=item Edit each queue to be categorized and set QueueCategory as desired

=back

=head2 C<$QueueCategories_CFName>

An alternative custom field name to use.

=head1 AUTHOR

NETWAYS GmbH L<support@netways.de|mailto:support@netways.de>

=head1 BUGS

All bugs should be reported at L<GitHub|https://github.com/NETWAYS/rt-extension-queuecategories/issues>.

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2018 by NETWAYS GmbH

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
