Plugin('RTx::CreateLinkedTickets');

Set($RTx_CreateLinkedTickets_Config, [
	{
		name		=> 'clt-billing',
		title		=> 'Create Billing Ticket',
		template	=> 'CLT-Billing'
	},
	{
		name		=> 'clt-eventattendee',
		title		=> 'Create Event Attendee',
		template	=> 'CLT-EventAttendee'
	}

]);
