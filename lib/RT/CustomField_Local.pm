package RT::CustomField;

use strict;
no warnings qw(redefine);
use vars qw(%FieldTypes);

$FieldTypes{'DBCustomField'} = {
	sort_order => 83,
    selection_type => 1,
    labels => [
		'Select multiple values with autocompletion from db source',      # loc
		'Select one value with autocompletion from db source',            # loc
		'Select up to [_1] values with autocompletion from db source',    # loc
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
	if ($self->Type eq 'DBCustomField') {
    	if (exists(RT->Config->Get('RTx_DBCustomField_Fields')->{$self->Name})) {
    		return 1;
    	}
    	elsif (exists(RT->Config->Get('RTx_DBCustomField_Fields')->{$self->Id})) {
    		return 1;
    	}
    }
}

1;