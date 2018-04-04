Plugin('RT::Extension::EmailHeader');

Set($EmailHeader_AdditionalHeaders, {
	'Return-Path' => 'rt+__Ticket(id)__@rt.netways.de'
});
Set($EmailHeader_OverwriteSendmailArgs, '-f rt+__Ticket(id)__@rt.netways.de');
