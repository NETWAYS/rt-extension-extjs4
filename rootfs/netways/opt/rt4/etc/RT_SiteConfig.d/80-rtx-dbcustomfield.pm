Plugin('RTx::DBCustomField');


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
