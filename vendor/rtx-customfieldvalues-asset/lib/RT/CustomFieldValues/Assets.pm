package RT::CustomFieldValues::Assets;

use version;

our $VERSION = 0.1.0;

use base qw(RT::CustomFieldValues::External);

sub SourceDescription {
  return 'RT::Assets provider';
}

# actual values provider method
sub ExternalValues {
  my $self = shift;
  my $cfid = $self->{__external_cf_limits}[0]->{VALUE};
  my $cf = RT::CustomField->new($self->CurrentUser);
  $cf->Load($cfid);

  return [] unless ($cf->Id);

  if ($cf->Description =~ m/catalog:\s*(\d+)/) {
    my $cid = $1;
    my $assets = RT::Assets->new($self->CurrentUser);
    $assets->Limit(
      FIELD => 'catalog',
      OPERATOR => '=',
      VALUE => $cid
    );
    my @out;
    while (my $asset = $assets->Next()) {
      push(@out, {
        name => $asset->Name
      });
    }
    return \@out;
  }

  return [];
}

1;
