use strict;
use warnings;
package RT::Extension::Netways;

our $VERSION = '1.1.0';

RT->AddStyleSheets('netways.css');

=head1 NAME

RT-Extension-Netways - Changes on the RT system for the NETWAYS workflow

=head1 DESCRIPTION

Some special features for the NETWAYS GmbH.

http://www.netways.de

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

=head1 AUTHOR

NETWAYS GmbH <lt>info@netways.de<gt>

=for html <p>All bugs should be reported via email to <a
href="mailto:bug-RT-Extension-Netways@rt.cpan.org">bug-RT-Extension-Netways@rt.cpan.org</a>
or via the web at <a
href="http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-Netways">rt.cpan.org</a>.</p>

=for text
    All bugs should be reported via email to
        bug-RT-Extension-Netways@rt.cpan.org
    or via the web at
        http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-Netways

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2018 by NETWAYS GmbH

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
