use strict;
no warnings qw(redefine);

package RT::I18N;

sub IsTextualContentType {
    my $type = shift;
    ($type =~ m{^(?:text/(?:plain|html|calendar)|message/rfc822)\b}i) ? 1 : 0;
}

1;
