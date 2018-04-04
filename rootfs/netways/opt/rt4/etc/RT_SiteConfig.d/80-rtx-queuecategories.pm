Plugin('RTx::QueueCategories');

Set($RTx_QueueCategories_Map, [
	{
		name => '01. Inboxes',
		items => ['Inbox Allgemein', 'Inbox Automails']
	}, {
		name => '02. Organisation',
		items => ['Admin Aufgaben', 'Admin Beschaffung', 'Buha Aufgaben', 'Buha Kontingente', 'Buha Projekte', 'NETWAYS Billing', 'NETWAYS Holiday']
	}, {
		name => '03. Management',
		items => ['MA Aufgaben', 'MA Jobs']
	}, {
		name => '04. Managed Services',
		items => ['MS Infrastruktur', 'MS Support Hosting', 'MS Support NWS', 'MS Support Internal']
	}, {
		name => '05. Professional Services',
		items => ['PS Aufgaben intern', 'PS Aufgaben extern', 'PS Aufgaben stalled', 'PS Support']
	}, {
		name => '06. Development',
		items => ['DEV Aufgaben intern', 'DEV Aufgaben extern']
	}, {
		name => '07. Sales & Shop',
		items => ['Sales Aufgaben intern', 'Sales Aufgaben extern', 'Sales Beschaffung', 'Shop Bestellungen', 'Shop Aufgaben']
	}, {
		name => '08. Events & Marketing',
		items => ['Event Aufgaben', 'Training Aufgaben', 'Marketing Aufgaben', 'Marketing Grafik']
	}, {
		name => '09. Teilnehmerqueues',
		items => ['TM Training', 'TM OSMC', 'TM OSDC', 'TM OSCAMP', 'TM OSBC', 'TM DOST', 'TM DevOpsDays', 'VT OSMC', 'VT OSDC', 'VT OSCAMP', 'VT OSBC', 'VT DOST', 'TM Events']
	}
]);
