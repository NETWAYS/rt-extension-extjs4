# https://docs.bestpractical.com/rt/4.4.4/RT_Config.html

Set($UserSearchResultFormat, qq{
  '<a href="__WebPath__/User/Summary.html?id=__id__">__id__</a>/TITLE:#',
  '<a href="__WebPath__/User/Summary.html?id=__id__">__Name__</a>/TITLE:Name',
  __RealName__,
  __EmailAddress__,
  __CustomField.{Department}__}
);

Set(%AdminSearchResultFormat,
  'Queues' => '\'<a href="__WebPath__/Admin/Queues/Modify.html?id=__id__">__id__</a>/TITLE:#\',\'<a href="__WebPath__/Admin/Queues/Modify.html?id=__id__">__Name__</a>/TITLE:Name\',__Description__,__Address__,__Priority__,__DefaultDueIn__,__Lifecycle__,__CustomField.{QueueCategory}__,__SubjectTag__,__Disabled__,__SortOrder__',
  'Groups' => '\'<a href="__WebPath__/Admin/Groups/Modify.html?id=__id__">__id__</a>/TITLE:#\',\'<a href="__WebPath__/Admin/Groups/Modify.html?id=__id__">__Name__</a>/TITLE:Name\',\'__Description__\',__Disabled__',
  'CustomRoles' => '\'<a href="__WebPath__/Admin/CustomRoles/Modify.html?id=__id__">__id__</a>/TITLE:#\',\'<a href="__WebPath__/Admin/CustomRoles/Modify.html?id=__id__">__Name__</a>/TITLE:Name\',__Description__,__MaxValues__,__Disabled__',
  'Templates' => '\'<a href="__WebPath__/__WebRequestPathDir__/Template.html?Queue=__QueueId__&Template=__id__">__id__</a>/TITLE:#\',\'<a href="__WebPath__/__WebRequestPathDir__/Template.html?Queue=__QueueId__&Template=__id__">__Name__</a>/TITLE:Name\',\'__Description__\',\'__UsedBy__\',\'__IsEmpty__\'',
  'CustomFields' => '\'<a href="__WebPath__/Admin/CustomFields/Modify.html?id=__id__">__id__</a>/TITLE:#\',\'<a href="__WebPath__/Admin/CustomFields/Modify.html?id=__id__">__Name__</a>/TITLE:Name\',__AddedTo__, __EntryHint__, __FriendlyPattern__,__Disabled__',
  'Classes' => ' \'<a href="__WebPath__/Admin/Articles/Classes/Modify.html?id=__id__">__id__</a>/TITLE:#\',\'<a href="__WebPath__/Admin/Articles/Classes/Modify.html?id=__id__">__Name__</a>/TITLE:Name\',__Description__,__Disabled__',
  'Catalogs' => '\'<a href="__WebPath__/Admin/Assets/Catalogs/Modify.html?id=__id__">__id__</a>/TITLE:#\',\'<a href="__WebPath__/Admin/Assets/Catalogs/Modify.html?id=__id__">__Name__</a>/TITLE:Name\',__Description__,__Lifecycle__,__Disabled__',
  'Users' => '\'<a href="__WebPath__/Admin/Users/Modify.html?id=__id__">__id__</a>/TITLE:#\',\'<a href="__WebPath__/Admin/Users/Modify.html?id=__id__">__Name__</a>/TITLE:Name\',__RealName__, __EmailAddress__,__Organization__,__CustomField.{Department}__,__Disabled__',
  'Scrips' => '\'<a href="__WebPath__/Admin/Scrips/Modify.html?id=__id____From__">__id__</a>/TITLE:#\',\'<a href="__WebPath__/Admin/Scrips/Modify.html?id=__id____From__">__Description__</a>/TITLE:Description\',__Condition__, __Action__, __Template__, __Disabled__'
);
Set ($DefaultSearchResultFormat, qq{
  '<B><A HREF="__WebPath__/Ticket/Display.html?id=__id__">__id__</a></B>/TITLE:#',
  '__Icon__',
  '__CustomField.\{Client\}__/TITLE:Client',
  '<B><A HREF="__WebPath__/Ticket/Display.html?id=__id__">__Subject__</a></B>/TITLE:Subject',
  Status,
  QueueName,
  OwnerName,
  Priority,
  '__NEWLINE__',
  '__NBSP__',
  '__NBSP__',
  '__NBSP__',
  '<small>__Requestors__</small>',
  '<small>__CreatedRelative__</small>',
  '<small>__ToldRelative__</small>',
  '<small>__LastUpdatedRelative__</small>',
  '<small>__TimeLeft__</small>'}
);