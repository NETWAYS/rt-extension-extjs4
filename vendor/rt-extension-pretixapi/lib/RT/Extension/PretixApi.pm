package RT::Extension::PretixApi;

use strict;
use warnings;

require Exporter;

use RT;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(
    $VERSION
    $AUTH_TOKEN
    $BASE_URI

);

our $VERSION = '0.9.1';

our $AUTH_TOKEN = RT->Config->Get('Pretix_Api_Auth_Token') // {};

die('$Pretix_Api_Auth_Token not configured') unless ($AUTH_TOKEN);

our $BASE_URI   = RT->Config->Get('Pretix_Api_Base_URI') // '';

die('$Pretix_Api_Base_URI not configured') unless ($BASE_URI);

=head1 NAME

RT-Extension-PretixApi

=head1 DESCRIPTION

Access data from pretix tickets and display or add to request tracker

=head1 RT VERSION

Works with RT 4.4.3.

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::PretixApi');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 AUTHOR

NETWAYS GmbH <support@netways.de>

=head1 BUGS

All bugs should be reported on GitHub
    <https://github.com/NETWAYS/rt-extension-pretixapi>.

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2018 by NETWAYS GmbH

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
