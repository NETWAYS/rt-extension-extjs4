Plugin('RT::Extension::DBCustomField');

Set($DBCustomField_DisablePool, 0);
Set($DBCustomField_Suggestion_Limit, 10);

# Connections
Set($DBCustomField_Connections, {
	'sugarcrm' => {
		'dsn'		=> 'DBI:mysql:database=sugarcrm;host=mysql2.adm.netways.de;port=3306;mysql_enable_utf8=1',
		'username'	=> 'sugarcrm',
		'password'	=> '5qk8LiDqsVgq',
		'autoconnect'	=> 1
	},

	'rt4' => {
       		'dsn' 		=> 'DBI:mysql:database=rt4_net_support;host=mysql1.adm.netways.de;port=3306;mysql_enable_utf8=1',
	        'username' 	=> 'reporting',
	        'password' 	=> 'Yee3IeSh',
	        'autoconnect' 	=> 1
	}

});

# Queries
Set ($DBCustomField_Queries, {
	# Companies from SugarCRM
	'companies' => {
		# The connection to use
       		'connection'    => 'sugarcrm',

		# The query to fetch auto-completion suggestions with. `field_value' is mandatory
		# and any occurrence of `?' is replaced with a user's input.
		'suggestions' => q{
			SELECT
			cstm.net_global_id_c AS field_value,
			cstm.shortname_c AS shortname,
			a.name AS name
			FROM accounts a
			INNER JOIN accounts_cstm cstm ON cstm.id_c = a.id AND cstm.net_global_id_c
			WHERE a.deleted=0 AND (
				cstm.net_global_id_c = ? OR cstm.shortname_c LIKE ? OR a.name LIKE ?
			)
			ORDER BY shortname
		},

		# The display template to use for each entry returned by the suggestions query. To reference specific
		# columns here encapsulate their name with curly braces. The default is just `{field_value}'
		# HTML support: Yes
		'suggestions_tpl' => q{
		    <div>
			<strong>{shortname}</strong>
			<div>{name} (<strong>{field_value}</strong>)</div>
		    </div>
		},

		# The query to fetch display values with. `field_value' is only required when not defining
		# a custom display template. A single occurrence of `?' is replaced with the value internally
		# stored by RT.
		'display_value' => q{
			SELECT
			cstm.net_global_id_c AS field_value,
			cstm.shortname_c AS shortname
			FROM accounts a
			INNER JOIN accounts_cstm cstm ON cstm.id_c = a.id AND cstm.net_global_id_c
			WHERE cstm.net_global_id_c = ?
		},

		# The display template to use when showing the custom field value to users. To reference specific
		# columns here encapsulate their name with curly braces. The default is just `{field_value}'.
		# HTML support: Yes, but try to avoid manipulating the layout too much (e.g. with block elements)
		'display_value_tpl' => '{shortname} (<i>{field_value}</i>)'
	},

	# RT Recipients, Urlaubsvertretung
	'rt4users' => {
		# The connection to use
		'connection'	=> 'rt4',

		# The query to fetch auto-completion suggestions with. `field_value' is mandatory
		# and any occurrence of `?' is replaced with a user's input.
		'suggestions' 	=> q{
			SELECT
			u.id AS field_value,
			u.RealName AS realname,
			u.NickName AS nickname
			FROM Users u
			INNER JOIN GroupMembers m ON m.memberid = u.id
			INNER JOIN Groups g ON g.id = m.groupid
			INNER JOIN Principals p ON p.id = u.id
			WHERE g.name = 'NETWAYS'
			AND p.Disabled = 0
			AND u.Realname NOT LIKE ''
			AND u.Realname != 'NETWAYS'
			AND (
				u.RealName LIKE ? OR u.NickName LIKE ?
			)
			order by u.RealName
		},

		# The display template to use for each entry returned by the suggestions query. To reference specific
		# columns here encapsulate their name with curly braces. The default is just `{field_value}'
		# HTML support: Yes
		'suggestions_tpl' => q{
			<div>
				<div>{realname} (<strong>{nickname}</strong>)</div>
			</div>
		},

		# The query to fetch display values with. `field_value' is only required when not defining
		# a custom display template. A single occurrence of `?' is replaced with the value internally
		# stored by RT.
		'display_value'   => q{
			SELECT
			u.id AS field_value,
			u.RealName AS realname,
			u.NickName AS nickname
			FROM Users u
			WHERE u.id = ?
		},

		# The display template to use when showing the custom field value to users. To reference specific
		# columns here encapsulate their name with curly braces. The default is just `{field_value}'.
		# HTML support: Yes, but try to avoid manipulating the layout too much (e.g. with block elements)
		'display_value_tpl' => '{realname} (<i>{nickname}</i>)'
	},

	# Opportunities from SugarCRM
	'opportunities' => {
		# The connection to use
		'connection'    => 'sugarcrm',

		# The query to fetch auto-completion suggestions with. `field_value' is mandatory
		# and any occurrence of `?' is replaced with a user's input.
		'suggestions' 	=> q{
			SELECT
			opportunities.id AS field_value,
			opportunities.name AS opportunity,
			accounts.name AS name,
			cstm.net_global_id_c AS globalid,
			cstm.shortname_c AS shortname
			FROM accounts_opportunities ao
			LEFT JOIN accounts ON ao.account_id = accounts.id
			INNER JOIN accounts_cstm cstm ON cstm.id_c = accounts.id
			LEFT JOIN opportunities ON ao.opportunity_id = opportunities.id
			WHERE accounts.deleted = 0
			AND (
				cstm.net_global_id_c = ? OR cstm.shortname_c LIKE ? OR accounts.name LIKE ? OR opportunities.name LIKE ?
			)
			ORDER BY opportunity
		},

		# The display template to use for each entry returned by the suggestions query. To reference specific
		# columns here encapsulate their name with curly braces. The default is just `{field_value}'
		# HTML support: Yes
		'suggestions_tpl' => q{
		    <div>
			<div><i>{opportunity}</i> (<strong>{shortname}</strong>)</div>
			<div>{name} (<strong>{globalid}</strong>)</div>
		    </div>
		},

		# The query to fetch display values with. `field_value' is only required when not defining
		# a custom display template. A single occurrence of `?' is replaced with the value internally
		# stored by RT.
		'display_value'   => q{
			SELECT
			opportunities.id AS field_value,
			opportunities.name AS opportunity,
			accounts.name AS name,
			cstm.net_global_id_c AS globalid,
			cstm.shortname_c AS shortname
			FROM accounts_opportunities ao
			LEFT JOIN accounts ON ao.account_id = accounts.id
			INNER JOIN accounts_cstm cstm ON cstm.id_c = accounts.id
			LEFT JOIN opportunities ON ao.opportunity_id = opportunities.id
			WHERE accounts.deleted = 0
			AND opportunities.id = ?
			ORDER BY opportunity
		},

		# The display template to use when showing the custom field value to users. To reference specific
		# columns here encapsulate their name with curly braces. The default is just `{field_value}'.
		# HTML support: Yes, but try to avoid manipulating the layout too much (e.g. with block elements)
               'display_value_tpl' => q{{opportunity} ({shortname}, {globalid})}
	}
});

# Query to CF mapping
Set($DBCustomField_Fields, {
	'Client'	=> 'companies',
	'Opportunity'	=> 'opportunities',
	'Vertreter'	=> 'rt4users',
	'Recipient'	=> 'rt4users',
});
