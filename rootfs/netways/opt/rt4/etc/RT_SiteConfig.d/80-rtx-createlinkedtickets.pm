Plugin('RT::Extension::CreateLinkedTickets');

Set($CreateLinkedTickets_Config, [
	{
		name		=> 'clt-billing',
		title		=> 'Create Billing Ticket',
		template	=> 'CLT-Billing',
		icon		=> 'cart-plus'
	},
	{
		name		=> 'clt-eventattendee',
		title		=> 'Create Event Attendee',
		template	=> 'CLT-EventAttendee',
		icon		=> 'bed'
	}
]);
