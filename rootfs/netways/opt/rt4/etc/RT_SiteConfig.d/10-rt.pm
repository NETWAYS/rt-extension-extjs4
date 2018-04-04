Set($MessageBoxIncludeSignature, undef);
Set($MessageBoxIncludeSignatureOnComment, undef);
Set($MessageBoxRichText, undef);
Set($TrustHTMLAttachments, 1);
Set($OldestTransactionsFirst, 0);
Set($MaxAttachmentSize, 25_000_000);
Set($MaxInlineBody, 8000000);
Set($SuppressInlineTextFiles, 1);
Set($ParseNewMessageForTicketCcs, 1);
Set($ShowHistory, 'delay');
Set($RedistributeAutoGeneratedMessages, "privileged");
Set($UsernameFormat, "verbose");
Set ($DefaultSearchResultFormat, qq{
  '<B><A HREF="__WebPath__/Ticket/Display.html?id=__id__">__id__</a></B>/TITLE:#',
  '__CustomField.\{Client\}__/TITLE:Client',
  '<B><A HREF="__WebPath__/Ticket/Display.html?id=__id__">__Subject__</a></B>/TITLE:Subject',
  Status,
  QueueName,
  OwnerName,
  Priority,
  '__NEWLINE__',
  '', '',
  '<small>__Requestors__</small>',
  '<small>__CreatedRelative__</small>',
  '<small>__ToldRelative__</small>',
  '<small>__LastUpdatedRelative__</small>',
  '<small>__TimeLeft__</small>'}
);
Set(%FullTextSearch,
   Enable  => 1,
   Indexed => 0,
);

