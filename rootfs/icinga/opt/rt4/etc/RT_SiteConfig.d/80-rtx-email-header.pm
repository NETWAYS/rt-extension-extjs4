Plugin('RT::Extension::EmailHeader');

Set($EmailHeader_AdditionalHeaders, {
    'Return-Path' => 'rt+__Ticket(id)__@rt.icinga.com'
});
Set($EmailHeader_OverwriteSendmailArgs, '-f rt+__Ticket(id)__@rt.icinga.com');
