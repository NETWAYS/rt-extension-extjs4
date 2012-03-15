package RTx::CreateLinkedTickets;

use version;

our $VERSION="1.0.0";

use strict;

use Data::Dumper;
use RT::Action::CreateTickets;

use vars qw (
	$config
);

$config = RT->Config->Get('RTx_CreateLinkedTickets_Config') || ();

use subs qw {
	createLinkedTicket
	getConfigurationByName
};

sub getConfigurationByName {
	my $name = shift;
	my @items = grep { $_->{'name'} eq $name } @{$config};
	if (scalar(@items) eq 1) {
		return shift @items;
	}
}

sub createTicketByConfiguration {
	my $a = {
		Ticket	=> undef,
		Config	=> undef,
		User	=> undef,
		@_
	};
	
	my $c = getConfigurationByName($a->{'Config'});
	
	return unless (ref($c) eq 'HASH');
	
	my $Ticket = $a->{'Ticket'};
	my $User = $a->{'User'};
	my $msg = undef;
	
	$User = $Ticket->CurrentUser unless($User);
	
	my $Template = RT::Template->new($User);
	$Template->Load($c->{'template'});
	
	if (!$Template->Id) {
		return (undef, loc('Could not load template'). ': '. $c->{'template'}, undef);
	}
	
	my $Transaction = RT::Transaction->new(
		Type			=> 'CreateLinkedTicket',
		ObjectType 		=> ref($Ticket),
		ObjectId		=> $Ticket->Id
	);
	
	my $Action = RT::Action::CreateTickets->new(
		CurrentUser	=> $User,
		TemplateObj	=> $Template,
		TicketObj	=> $Ticket
	);
	
	unless ($Action->Prepare()) {
		return (undef, 'Could not prepare action', undef);
	}
	
	unless ($Action->Commit()) {
		return (undef, 'Could not commit action', undef);
	}
	
	return (1, 'Linked ticket created. Please see links section to validate.');
}

1;
