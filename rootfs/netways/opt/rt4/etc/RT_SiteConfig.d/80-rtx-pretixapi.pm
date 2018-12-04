Plugin('RT::Extension::PretixApi');

Set($Pretix_Api_Auth_Token, {
'icinga' => 'c37kgx2ejqg14vompevekhardqh08o7delcwj08w1yy71ihohvvzrwzx19ap1l7z',
'nes'    => 'u1uo6eklpf2c6mw11g69x4dbzk3mifq09u6thhw5g5t3todzv0umrfxhalqklg0s',
'b1'     => 'gby7f3bic4aq6buy4ymzngbhotmr8w7oyd3czbt03zl4sw15m307zsl9mrq1t89l'
}); # Must be a hash

Set($Pretix_Api_Base_URI, 'https://tickets.netways.de/api/v1');
Set($Pretix_Sender_Regexp, qr{^tickets\@netways\.de$});

Set($Pretix_Top_Resolve_Ticket, 1);
Set($Pretix_Queue_Default, 117); # TM Conference
Set($Pretix_Queue_SubEvent, 54); # TM Training
Set($Pretix_Twitter_QuestionId, 'twitter');

Set($Pretix_Top_Subject_Format, '{$event_name} | A new order has been placed {$order}');
Set($Pretix_Attendee_Subject_Format, '{$event_name} | {$date_from} (TN: {$name}), Order Code: {$order}');
