Set($rtname, 'icinga');
Set($Organization, "icinga.org");

Set($WebDomain, 'rt.icinga.org');
Set($WebPath, "");
Set($WebPort, 443);
Set($Timezone, "Europe/Berlin");

Set($DatabaseType, "mysql");
Set($DatabaseHost,   "192.168.0.1");
Set($DatabaseUser, "rt4_user");
Set($DatabasePassword, q{R75qk8Pd6PNzgJX});
Set($DatabaseName, "rt4_icinga_support");

Set($LogToSyslog, "error");
Set($LogToSTDERR, undef);
Set($LogToFile, undef);
Set($LogStackTraces, undef);

# XSS referrer check
Set($RestrictReferrer, undef);

Set($MessageBoxIncludeSignature, undef);
Set($MessageBoxIncludeSignatureOnComment, undef);
Set($MessageBoxRichText, undef);
Set($TrustHTMLAttachments, 1);
Set($OldestTransactionsFirst, 0);

Set($MaxAttachmentSize, 25_000_000);
Set($ParseNewMessageForTicketCcs, 1);

# Set($RTAddressRegexp, '^.+\@rt.netways.de$');
Set($RTAddressRegexp, '^(info|xrt|rt|events|shop|partner|support)\@(rt\.)?icinga\.org$');
Set($CorrespondAddress , 'rt@icinga.org');
Set($CommentAddress , 'xrt@icinga.org');
Set($SetOutgoingMailFrom, 1);

# Default setting
Set($RedistributeAutoGeneratedMessages, "privileged");

Set($UsernameFormat, "verbose");

# Full text search
Set(%FullTextSearch,
   Enable  => 1,
   Indexed => 0,
);

# Mason performance
Set(@MasonParameters, (
       static_source => 1,
       buffer_preallocate_size => 16777216, # 16MB
       data_cache_defaults => {
           cache_class => "MemoryCache",
           cache_depth => 8
       },
       # preloads => ['/Elements/*']
));

Plugin('RT::Extension::ExtractCustomFieldValues');
Plugin('RTx::CreateLinkedTickets');
Plugin('RTx::ExtJS4');
Plugin('RTx::QueueCategories');
Plugin('RTx::UpdateHistory');
Plugin('RTx::Action::SetOwner');
Plugin('RTx::DBCustomField');
Plugin('RTx::HistoryComponent');
Plugin('RTx::SearchMarker');
Plugin('RTx::UserSearch');
Plugin('RTx::AddServiceData');
Plugin('RTx::EmailHeader');
Plugin('RTx::NETWAYS');
Plugin('RTx::TicketActions');
Plugin('RT::Authen::ExternalAuth');

# Plugin configuration

# Authentication
Set($WebRemoteUserAuth, 1);
Set($WebFallbackToRTLogin, 1);
Set($AutoCreateNonExternalUsers, 0);
Set($ExternalAuthPriority, ['icinga-ldap']);
Set($ExternalInfoPriority, ['icinga-ldap']);
Set($UserAutocreateDefaultsOnLogin, {
  Privileged => 1
});
Set($ExternalSettings, {
  'icinga-ldap' => {
    'type' => 'ldap',
    'server' => 'icinga-tool.icinga.netways.de',
    'user' => 'cn=auth-http,ou=users,dc=icinga,dc=org',
    'pass' => '6UYHE32X',
    'base' => 'ou=people,dc=icinga,dc=org',
    'filter' => '(&(objectClass=inetOrgPerson))',
    'group' => 'cn=icinga-rt,ou=groups,dc=icinga,dc=org',
    'group_attr' => 'member',
    'group_scope' => 'sub',
    'attr_match_list' => [
      'Name',
      'EmailAddress',
    ],
    'attr_map' => {
      'Name'         => 'uid',
      'EmailAddress' => 'mail',
      'RealName'     => 'cn',
    }
  }
});

Set($RTx_EmailHeader_AdditionalHeaders, {
    'Return-Path' => 'rt+__Ticket(id)__@rt.netways.de'
});

Set($RTx_EmailHeader_OverwriteSendmailArgs, '-f rt+__Ticket(id)__@rt.icinga.org');

Set($RTx_NETWAYS_EnableQuickAssign, 1);
Set($RTx_NETWAYS_QuickAssignGroup, 'icinga-edit');

Set($RTx_NETWAYS_UserRequestorGroup, 'icinga-edit');
Set($RTx_NETWAYS_EnableTagFormat, 1);

Set($RTx_NETWAYS_ShowSearchOnlyWithResults, 0);

Set($RTx_TicketActions_ShowQuickAccess, 1);
Set($RTx_TicketActions_FontAwesome, 'https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css');

Set($HomepageComponents, [qw(
    QuickCreate
    Quicksearch
    MyAdminQueues
    MySupportQueues
    MyReminders
    RefreshHomepage
    Dashboards
    SavedSearches
    RTx-UserSearch
    RTx-TicketHistory
)]);
