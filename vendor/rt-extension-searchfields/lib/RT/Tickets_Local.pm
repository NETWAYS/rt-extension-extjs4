use strict;
no warnings qw(redefine);

package RT::Tickets;

use Data::Dumper;

$RT::Tickets::FIELD_METADATA{'LastUpdater'} = ['USERFIELD' => 'LastUpdatedBy'];
$RT::Tickets::dispatch{'USERFIELD'} = \&_UserFieldLimit;

sub _UserFieldLimit {
  my ( $sb, $field, $op, $value, %rest ) = @_;

  my $meta = $RT::Tickets::FIELD_METADATA{$field};
  my $joinField = $meta->[1];

  if (exists $rest{'SUBKEY'} && $rest{'SUBKEY'}) {
    my $alias = $sb->Join(
      TYPE   => 'INNER',
      ALIAS1 => 'main',
      FIELD1 => $joinField,
      TABLE2 => 'Users',
      FIELD2 => 'Id',
    );

    $sb->Limit(
      LEFTJOIN        => $alias,
      FIELD           => $rest{'SUBKEY'},
      OPERATOR        => $op,
      VALUE           => $value,
      ENTRYAGGREGATOR => 'AND'
    );

    return;
  } elsif (defined $value && $value !~ /^\d+$/) {
    my $user = RT::User->new($sb->CurrentUser);
    $user->Load($value);
    $value = $user->Id || 0;
  }

  $sb->Limit(
    FIELD           => 'LastUpdatedBy',
    OPERATOR        => $op,
    VALUE           => $value,
    ENTRYAGGREGATOR => 'AND'
  );
}
1;
