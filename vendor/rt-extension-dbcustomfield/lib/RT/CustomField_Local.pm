package RT::CustomField;

use strict;
no warnings qw(redefine);
use vars qw(%FieldTypes);

$FieldTypes{'DBCustomField'} = {
	sort_order => 83,
    selection_type => 1,
    labels => [
		'Select one value with autocompletion from db source' # loc
	]
};

sub IsExternalValues {
    my $self = shift;
    return 1 if ($self->isDBCustomField());
    return 0 unless $self->IsSelectionType( @_ );
    return $self->ValuesClass eq 'RT::CustomFieldValues'? 0 : 1;
}

sub isDBCustomField {
	my $self = shift;
	if ($self->Type eq 'DBCustomField' && defined(RT->Config->Get('DBCustomField_Fields'))) {
    	if (exists(RT->Config->Get('DBCustomField_Fields')->{$self->Name})) {
    		return 1;
    	}
    	elsif (exists(RT->Config->Get('DBCustomField_Fields')->{$self->Id})) {
    		return 1;
    	}
    }
}

1;
