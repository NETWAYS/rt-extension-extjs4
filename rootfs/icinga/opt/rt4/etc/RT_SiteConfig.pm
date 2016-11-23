Set($rtname, 'icinga');
Set($Organization, "icinga.com");

Set($WebDomain, 'rt.icinga.com');
Set($WebPath, "");
Set($WebPort, 443);
Set($Timezone, "Europe/Berlin");

Set($DatabaseType, "mysql");
Set($DatabaseHost,   "mysql.icinga.netways.de");
Set($DatabaseUser, "rt4_user");
Set($DatabasePassword, q{R75qk8Pd6PNzgJX});
Set($DatabaseName, "rt4");

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
Set($MaxInlineBody, 8000000);
Set($SuppressInlineTextFiles, 1);
Set($ParseNewMessageForTicketCcs, 1);
Set($ShowHistory, 'delay');

Set($RTAddressRegexp, '^(info|xrt|rt|events|shop|partner|support|sales|automail|infrastructure)\@(rt\.)?icinga\.org$');
Set($CorrespondAddress , 'rt@icinga.com');
Set($CommentAddress , 'xrt@icinga.com');
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

Set($WebSessionClass, "Apache::Session::File");

Plugin('RT::Extension::ExtractCustomFieldValues');
Plugin('RTx::CreateLinkedTickets');
Plugin('RTx::ExtJS4');
Plugin('RTx::QueueCategories');
Plugin('RTx::UpdateHistory');
Plugin('RTx::Action::SetOwner');
Plugin('RTx::Action::ChangeOwner');
Plugin('RTx::DBCustomField');
Plugin('RTx::HistoryComponent');
Plugin('RTx::UserSearch');
Plugin('RTx::AddServiceData');
Plugin('RTx::EmailHeader');
Plugin('RTx::NETWAYS');
Plugin('RTx::TicketActions');

# Plugin configuration
# Gpg and SMIME
Set(%GnuPG,
    Enable                 => 0,
    GnuPG                  => 'gpg',
    Passphrase             => undef,
    OutgoingMessagesFormat => "RFC", # Inline
);

Set(%SMIME,
    Enable => 0,
    OpenSSL => 'openssl',
    Keyring => q{var/data/smime},
    CAPath => undef,
    AcceptUntrustedCAs => undef,
    Passphrase => undef,
);

# Authentication
Set($WebRemoteUserAuth, 1);
Set($WebFallbackToRTLogin, 1);
Set($AutoCreateNonExternalUsers, 1);
Set($ExternalAuthPriority, ['icinga-ldap']);
Set($ExternalInfoPriority, ['icinga-ldap']);
Set($UserAutocreateDefaultsOnLogin, {
  Privileged => 1
});
Set($ExternalSettings, {
  'icinga-ldap' => {
    'type' => 'ldap',
    'server' => 'icinga-ldap2.icinga.netways.de',
    'user' => 'cn=rt,ou=tools,dc=icinga,dc=com',
    'pass' => '45JRpo6bri',
    'base' => 'ou=user,dc=icinga,dc=com',
    'filter' => '(|(memberof=cn=rt,ou=groups,dc=icinga,dc=com)(memberof=cn=all-access,ou=groups,dc=icinga,dc=com))',
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
    'Return-Path' => 'rt+__Ticket(id)__@rt.icinga.com'
});

Set($RTx_EmailHeader_OverwriteSendmailArgs, '-f rt+__Ticket(id)__@rt.icinga.com');

Set($RTx_NETWAYS_EnableQuickAssign, 1);
Set($RTx_NETWAYS_QuickAssignGroup, 'icinga-edit');

Set($RTx_NETWAYS_UserRequestorGroup, 'icinga-edit');
Set($RTx_NETWAYS_EnableTagFormat, 1);

Set($RTx_NETWAYS_ShowSearchOnlyWithResults, 0);

Set($RTx_TicketActions_ShowQuickAccess, 1);
Set($RTx_TicketActions_FontAwesome, 'https://cdn.netways.de/font-awesome/4.5.0/css/font-awesome.min.css');

Set($HomepageComponents, [qw(
    QuickCreate
    Quicksearch
    QueueList
    MyAdminQueues
    MySupportQueues
    MyReminders
    RefreshHomepage
    Dashboards
    SavedSearches
    RTx-UserSearch
    RTx-TicketHistory
)]);
