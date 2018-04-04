Plugin('RTx::EmailHeader');

Set($RTx_EmailHeader_AdditionalHeaders, {
    'Return-Path' => 'rt+__Ticket(id)__@rt.icinga.com'
});

Set($RTx_EmailHeader_OverwriteSendmailArgs, '-f rt+__Ticket(id)__@rt.icinga.com');
