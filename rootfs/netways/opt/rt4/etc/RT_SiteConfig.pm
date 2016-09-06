# Any configuration directives you include  here will override
# RT's default configuration file, RT_Config.pm
#
# To include a directive here, just copy the equivalent statement
# from RT_Config.pm and change the value. We've included a single
# sample value below.
#
# This file is actually a perl module, so you can include valid
# perl code, as well.
#
# The converse is also true, if this file isn't valid perl, you're
# going to run into trouble. To check your SiteConfig file, use
# this comamnd:
#
#   perl -c /path/to/your/etc/RT_SiteConfig.pm
#
# You must restart your webserver after making changes to this file.

Set($rtname, 'netways');
Set($Organization, "netways.de");

Set($WebDomain, 'rt.netways.de');
Set($WebPath, "");
Set($WebPort, 443);
Set($Timezone, "Europe/Berlin");

Set($DatabaseType, "mysql");
Set($DatabaseHost,   "mysql1.adm.netways.de");
Set($DatabaseUser, "rt4_user");
Set($DatabasePassword, q{R75qk8Pd6PNzgJX});
Set($DatabaseName, "rt4_net_support");

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

# Set($RTAddressRegexp, '^.+\@rt.netways.de$');
Set($RTAddressRegexp, '^(nobody\@web\.|.+\@rt\.|(service|info|office|abuse|billing|changes|einkauf|events|fax|hardware|hostmaster|reports|.*support|sales|shop|sun|tradoria|tickets?|grafik|telekom|hq|jobs?)\@)netways\.de$');
Set($CorrespondAddress , 'rt@rt.netways.de');
Set($CommentAddress , 'xrt@rt.netways.de');
Set($SetOutgoingMailFrom, 1);

# Default setting
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
  '<small>__TimeLeft__</small>'});

Plugin('RTx::ExtJS4');
Plugin('RTx::DBCustomField');
Plugin('RTx::NETWAYS');
Plugin('RTx::UpdateHistory');
Plugin('RTx::TicketActions');
Plugin('RTx::CreateLinkedTickets');
Plugin('RTx::HistoryComponent');
Plugin('RTx::UserSearch');
Plugin('RTx::QueueCategories');
Plugin('RTx::Actitime');
Plugin('RTx::EmailHeader');
Plugin('RT::Extension::ExtractCustomFieldValues');
Plugin('RTx::SearchMarker');
Plugin('RTx::AddServiceData');
Plugin('RTx::Action::SetOwner');
Plugin('RTx::Action::SubjectAndEvent');
Plugin('RTx::Action::ChangeOwner');
Plugin('RT::CustomFieldValues::Assets');

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

### Plugin Konfiguration ###
# Customfield provider
Set(@CustomFieldValuesSources, "RT::CustomFieldValues::Assets");

# Authentication
Set($WebRemoteUserAuth, 1);
Set($WebFallbackToRTLogin, 1);
Set($AutoCreateNonExternalUsers, 1);
Set($ExternalAuthPriority, ['netways-ldap']);
Set($ExternalInfoPriority, ['netways-ldap']);
Set($UserAutocreateDefaultsOnLogin, {
  Privileged => 1
});
Set($ExternalSettings, {
  'netways-ldap' => {
    'type' => 'ldap',
    'server' => 'int.netways.de',
    'user' => 'netways-http@INT.NETWAYS.DE',
    'pass' => 'Zuriep2w',
    'base' => 'DC=int,DC=netways,DC=de',
    'filter' => '(&(objectClass=organizationalPerson)(userAccountControl:1.2.840.113556.1.4.803:=0)(memberOf=CN=net-rt-auth-HTTP,OU=AuthGroups,OU=NETWAYS,OU=NETRZ,OU=NETWAYS,DC=int,DC=netways,DC=de))',
    'd_filter' => '(&(userAccountControl:1.2.840.113556.1.4.803:=2))',
    'group' => 'CN=net-rt-auth-HTTP,OU=AuthGroups,OU=NETWAYS,OU=NETRZ,OU=NETWAYS,DC=int,DC=netways,DC=de',
    'group_attr' => 'member',
    'group_scope' => 'sub',
    'attr_match_list' => [
      'Name',
      'EmailAddress',
    ],
    'attr_map' => {
      'Name'         => 'sAMAccountName',
      'EmailAddress' => 'mail',
      'RealName'     => 'cn',
      'WorkPhone'    => 'telephoneNumber',
      'MobilePhone'  => 'mobile',
      'Address1'     => 'streetAddress',
      'City'         => 'l',
      'State'        => 'st',
      'Zip'          => 'postalCode',
      'Country'      => 'co',
      'NickName'     => 'initials',
      'Organization' => 'department'
    }
  }
});

Set($RTx_EmailHeader_AdditionalHeaders, {
	'Return-Path' => 'rt+__Ticket(id)__@rt.netways.de'
});

Set($RTx_EmailHeader_OverwriteSendmailArgs, '-f rt+__Ticket(id)__@rt.netways.de');

Set($RTx_NETWAYS_EnableQuickAssign, 1);
Set($RTx_NETWAYS_QuickAssignGroup, 'NETWAYS');

Set($RTx_NETWAYS_UserRequestorGroup, 'NETWAYS');
Set($RTx_NETWAYS_EnableTagFormat, 1);

Set($RTx_NETWAYS_ShowSearchOnlyWithResults, 0);

Set($RTx_TicketActions_ShowQuickAccess, 1);
Set($RTx_TicketActions_FontAwesome, 'https://cdn.netways.de/font-awesome/4.5.0/css/font-awesome.min.css');

Set($RTx_QueueCategories_Map, [
	{
		name => '01. Inboxes',
		items => ['Inbox Allgemein', 'Inbox Automails']
	}, {
		name => '02. Organisation',
		items => ['Admin Aufgaben', 'Admin Beschaffung', 'Buha Aufgaben', 'Buha Kontingente', 'NETWAYS Billing', 'NETWAYS Holiday']
	}, {
		name => '03. Management',
		items => ['MA Aufgaben', 'MA Jobs']
	}, {
		name => '04. Managed Services',
		items => ['MS Infrastruktur', 'MS Support Hosting', 'MS Support Contracts']
	}, {
		name => '05. Professional Services',
		items => ['PS Aufgaben intern', 'PS Aufgaben extern', 'PS Aufgaben stalled']
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
		items => ['TM Training', 'TM OSMC', 'TM OSDC', 'TM OSBC', 'TM DOST', 'TM DevOpsDays', 'VT OSMC', 'VT OSDC', 'VT OSBC', 'VT DOST', 'TM Events']
	}, {
		name => '10. Kunden',
		items => ['Blanco', 'DB Systel', 'Icinga', 'Telekom', 'Telekom T-Systems Leipzig']
	}
]);

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

Set($RTx_DBCustomField_DisablePool, 0);

Set($RTx_DBCustomField_Connections, {
	'sugarcrm' => {
		'dsn'			=> 'DBI:mysql:database=sugarcrm;host=mysql2.adm.netways.de;port=3306;mysql_enable_utf8=1',
		'username'		=> 'sugarcrm',
		'password'		=> '5qk8LiDqsVgq',
		'autoconnect'		=> 1
	},

	'actitime' => {
       	'dsn' => 'DBI:mysql:database=actitime;host=mysql2.adm.netways.de;port=3306;mysql_enable_utf8=1',
	        'username' => 'reporting',
	        'password' => 'Yee3IeSh',
	        'autoconnect' => 1
	},

	'rt4' => {
       	'dsn' => 'DBI:mysql:database=rt4_net_support;host=mysql1.adm.netways.de;port=3306;mysql_enable_utf8=1',
	        'username' => 'reporting',
	        'password' => 'Yee3IeSh',
	        'autoconnect' => 1
	}

});

Set ($RTx_DBCustomField_Queries, {
	'actitime' => {
		'connection' => 'actitime',
		'query' => q{
			SELECT __DBCF_FIELDS__
			from viewTimeSelect ts
			order by mode
		},

		'searchfields' => ['ts.mode', 'ts.divisor'],
		'searchop' => 'OR',

		'fields' => {
			'mode' => 'ts.mode',
			'divisor' => 'ts.divisor'
		},

		'field_tpl' => q{
			{mode}({divisor})
		},

		'field_id' => 'divisor',

		'returnquery' => q{
                       CALL sprTimeFromTicket(__TICKET(id)__, __VALUE__);
               },

               'returnfields' => {
               	'mode'			=> 'mode',
               	'divisor'		=> 'divisor',
               	'ticket'		=> 'ticket',
               	'c_billable'		=> 'c_billable',
               	'c_remote'		=> 'c_remote',
               	'c_onsite'		=> 'c_onsite',
               	'c_nonbillable'		=> 'c_nonbillable',
               	'nonbillable_taskid'	=> 'nonbillable_taskid',
               	'remote_taskid'		=> 'remote_taskid',
               	'onsite_taskid'		=> 'onsite_taskid',
               	'link'			=> 'link'
               },

               'returnfield_id' => 'divisor',

               'returnfield_config' => {
               	height => 100
               },

               'returnfield_tpl' => q{
               	Config type: {mode}({divisor})

               	<tpl if="c_billable">
               		<div>
               			<strong style="color: #009900;">Billable</strong>: {c_billable}
               			<dl style="padding: 0 0 0 0; margin: 0 0 0 0;">
               				<dd style="margin: 0 0 0 10px">
               					remote: {c_remote} (<a href="{link}{remote_taskid}" target="_blank">link</a>)
               				</dd>
               				<dd style="margin: 0 0 0 10px">
               					onsight: {c_onsite} (<a href="{link}{onsite_taskid}" target="_blank">link</a>)
               				</dd>
               			</dl>
               			<strong style="color: #cc0033;">Non-billable</strong>: {c_nonbillable} (<a href="{link}{nonbillable_taskid}" target="_blank">link</a>)
               		</div>
               	</tpl>

               },

               'returnfield_small_tpl' => q{
               		{mode} (billable: <strong style="color: #009900;">{c_billable}</strong>/<a href="{link}{remote_taskid}" target="_blank">{c_remote}</a>/<a href="{link}{onsite_taskid}" target="_blank">{c_onsite}</a>, non-billable: <a href="{link}{nonbillable_taskid}" target="_blank"><strong style="color: #cc0033;">{c_nonbillable}</strong></a>)}
		},

       'companies' => {

       		'connection'    => 'sugarcrm',

               'query' => q{
                       SELECT
                       __DBCF_FIELDS__
                       from accounts a
                       inner join accounts_cstm cstm on cstm.id_c = a.id and cstm.net_global_id_c
                       WHERE a.deleted=0 and (__DBCF_WHERE__)
                       order by shortname
                       LIMIT 300;
               },

               'searchfields'  => ['cstm.shortname_c', 'a.name', 'cstm.net_global_id_c'],
               'searchop'      => 'OR',

               'fields'         => {
               	'shortname'	=> 'cstm.shortname_c',
               	'globalid'	=> 'cstm.net_global_id_c',
               	'name'		=> 'a.name'
               },

               'field_id' => 'cstm.net_global_id_c',

               'field_tpl' => q{
               	<div>
	                	<tpl if="shortname">
	                		<div><span style="font-weight: bold;">{shortname}</span></div>
	                	</tpl>
	                	<div>{name} (<span style="font-weight: bold;">{globalid}</span>)</div>
               	</div>
              	},

              	'field_config' => {},

               'returnquery'   => q{
                       SELECT
                               __DBCF_FIELDS__
                       from accounts a
                       inner join accounts_cstm cstm on cstm.id_c = a.id and cstm.net_global_id_c
                       where a.deleted=0 and cstm.net_global_id_c=?
                       LIMIT 100
               },

               'returnfields'         => {
               	'shortname'	=> 'cstm.shortname_c',
               	'globalid'	=> 'cstm.net_global_id_c',
               	'name'		=> 'a.name'
               },

               'returnfield_id' => 'cstm.net_global_id_c',

               'returnfield_config' => {
               	height => 50
               },

               'returnfield_tpl' => q{
               	<div>
	                	<tpl if="shortname">
	                		<div><span style="font-weight: bold;">{shortname}</span></div>
	                	</tpl>
	                	<div>{name} (<span style="font-weight: bold;">{globalid}</span>)</div>
               	</div>
               },

               'returnfield_small_tpl' => q{{shortname} ({globalid})}


	},

	'rt4users' => {

                       'connection'    => 'rt4',

               'query' => q{
                       SELECT
                       __DBCF_FIELDS__
			from Users u
			inner join GroupMembers m on m.memberid = u.id
			inner join Groups g on g.id = m.groupid
			inner join Principals p on p.id = u.id
			where g.name = 'NETWAYS'
			and p.Disabled = 0
			and u.Realname not like ''
			and u.Realname != 'NETWAYS' and (__DBCF_WHERE__)
			order by u.RealName
			LIMIT 100;
               },

               'searchfields'  => ['u.RealName', 'u.NickName'],
               'searchop'      => 'OR',

               'fields'         => {
  			'id' 		=> 'u.id',
                       'realname'     => 'u.RealName',
                       'nickname'      => 'u.NickName'
               },

               'field_id' => 'u.id',

               'field_tpl' => q{
                       <div>
                               <tpl if="realname">
                                       <div><span style="font-weight: bold;">{realname} ({nickname})</span></div>
                               </tpl>
                       </div>
               },

               'field_config' => {},

               'returnquery'   => q{
                       SELECT
                       __DBCF_FIELDS__
                       from Users u
			where u.id=?
                       LIMIT 100
               },

               'returnfields'         => {
                       'id'     => 'u.id',
                       'realname'      => 'u.RealName',
                       'nickname'          => 'u.NickName'
               },

               'returnfield_id' => 'u.id',

               'returnfield_config' => {
                       height => 50
               },

               'returnfield_tpl' => q{
                       <div>
                               <tpl if="realname">
                                       <div><span style="font-weight: bold;">{realname} ({nickname})</span></div>
                               </tpl>
                       </div>
               },

               'returnfield_small_tpl' => q{{RealName} ({NickName})}


       },


	'opportunities' => {

       	'connection'    => 'sugarcrm',

               'query' => q{
					SELECT __DBCF_FIELDS__
					FROM accounts_opportunities as ao
					LEFT JOIN accounts
					on ao.account_id = accounts.id
					inner join accounts_cstm cstm
					on cstm.id_c = accounts.id
					LEFT JOIN opportunities
					on ao.opportunity_id = opportunities.id
					WHERE accounts.deleted=0 __DBCF_AND_WHERE__
					order by opportunity
					LIMIT 300;
               },

               'searchfields'  => ['cstm.shortname_c', 'accounts.name', 'cstm.net_global_id_c', 'opportunities.name'],
               'searchop'      => 'OR',

               'fields'         => {
               	'shortname'			=> 'cstm.shortname_c',
               	'globalid'			=> 'cstm.net_global_id_c',
               	'name'				=> 'accounts.name',
               	'opportunity'		=> 'opportunities.name',
               	'opportunity_id'	=> 'opportunities.id'
               },

               'field_id' => 'opportunities.id',

               'field_id_type' => 'string',

               'field_tpl' => q{
               	<div>
               		<div style="font-style: italic;">{opportunity}</div>
	                	<tpl if="shortname">
	                		<div><span style="font-weight: bold;">{shortname}</span></div>
	                	</tpl>
	                	<div>{name} (<span style="font-weight: bold;">{globalid}</span>)</div>
               	</div>
              	},

              	'field_config' => {},

               'returnquery'   => q{
                   SELECT __DBCF_FIELDS__
					FROM accounts_opportunities as ao
					LEFT JOIN accounts
					on ao.account_id = accounts.id
					inner join accounts_cstm cstm
					on cstm.id_c = accounts.id
					LEFT JOIN opportunities
					on ao.opportunity_id = opportunities.id
					WHERE accounts.deleted=0 and opportunities.id=?
					order by opportunity
					LIMIT 300;
               },

               'returnfields'         => {
               	'shortname'			=> 'cstm.shortname_c',
               	'globalid'			=> 'cstm.net_global_id_c',
               	'name'				=> 'accounts.name',
               	'opportunity'		=> 'opportunities.name',
               	'opportunity_id'	=> 'opportunities.id'
               },

               'returnfield_id' => 'opportunities.id',

               'returnfield_config' => {
               	height => 50
               },

               'returnfield_tpl' => q{
               	<div>
               		<div style="font-style: italic;">{opportunity}</div>
	                	<tpl if="shortname">
	                		<div><span style="font-weight: bold;">{shortname}</span></div>
	                	</tpl>
	                	<div>{name} (<span style="font-weight: bold;">{globalid}</span>)</div>
               	</div>
               },

               'returnfield_small_tpl' => q{{opportunity} ({shortname}, {globalid})}

	}

});

Set($RTx_DBCustomField_Fields, {
	'Client'	    => 'companies',
	'Opportunity'	=> 'opportunities',
	'Vertreter'	    => 'rt4users',
   'Recipient'     => 'rt4users',
	'Zeit erbracht'	=> 'actitime'
});

# Set($RTx_ExtJS4_TYPE, 'debug');

Set($RTx_Actitime_DisablePool, 0);
Set($RTx_Actitime_DB_DSN, 'DBI:mysql:database=actitime;host=mysql2.adm.netways.de;port=3306;mysql_enable_utf8=0');
Set($RTx_Actitime_DB_USER, 'reporting');
Set($RTx_Actitime_DB_PASS, 'Yee3IeSh');

Set($RTx_Actitime_PROJECT_NAME, 'p.name_lower');
Set($RTx_Actitime_CUSTOMER_NAME, 'c.name_lower');

Set($RTx_Actitime_PROJECT_QUERY, '[netways #%d]: %%');
Set($RTx_Actitime_CUSTOMER_QUERY, '%%[%d]%%');

Set($RTx_Actitime_CUSTOMER_FIELD_NAME, 'Client');

Set($RTx_Actitime_HTTP_URL, 'https://time.netways.de/actitime');

Set($RTx_Actitime_BUDGET_WARNING_PERCENT, 60);
Set($RTx_Actitime_BUDGET_CRITICAL_PERCENT, 90);

Set($RTx_Actitime_TASK_SHOW_ALL, 1);

Set($RTx_Actitime_TASK_CONFIGURATION, [{
   'name'      => 'Consulting',
   'active'    => ['vor ort', 'remote'],
   'inactive'  => ['nicht berechenbar'],

   'budget_warning_percent'    => 60,
   'budget_critical_percent'   => 90,
}]);

1;
