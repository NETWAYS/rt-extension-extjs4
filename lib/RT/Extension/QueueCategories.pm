package RT::Extension::QueueCategories;

use 5.10.1;
use strict;
use version;

our $VERSION='2.1.0';

=pod

=head1 NAME

RT::Extension::QueueCategories

=head1 DESCRIPTION

Allows you to categorize queues by a specific custom field.

In addition to the default functionality of custom fields, this extension utilizes the values of this custom field
to group queues in the following areas:

=over

=item Quick Ticket Creation Dropdown

The one in the top right corner.

=item QueueList Dashboard Element

The one that comes by default with RT.

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

    Plugin('RT::Extension::QueueCategories');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 CONFIGURATION

In order to enable this extension's functionality it is required to create a custom field first. This custom field
needs to be of the type "Select one value" and have the name "QueueCategory". (Although the name is configurable,
see below)

Once the custom field has been created, define the categories you want to use as values for the field. Remember to
apply the field to those queues you want to categorize and to manage authorization before continuing.

Now edit each queue you want to categorize and choose a value for the custom field. That's it.

=head2 Order of Categories

It's possible to adjust the order of categories by defining a sort order for each value of the custom field.
If no custom sort order is provided, categories are sorted alphabetically by default.

=head2 C<$QueueCategories_CFName>

An alternative custom field name to use.

=head3 Example

=over

=item C<Set($QueueCategories_CFName, 'Queue Group');>

=back

=head1 AUTHOR

NETWAYS GmbH <support@netways.de>

=head1 BUGS

All bugs should be reported on L<GitHub|https://github.com/NETWAYS/rt-extension-queuecategories>.

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2018 by NETWAYS GmbH

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
