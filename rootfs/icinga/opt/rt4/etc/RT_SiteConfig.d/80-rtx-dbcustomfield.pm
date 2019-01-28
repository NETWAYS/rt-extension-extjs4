Plugin('RT::Extension::DBCustomField');

Set($DBCustomField_DisablePool, 0);
Set($DBCustomField_Suggestion_Limit, 10);

# Connections
Set($DBCustomField_Connections, {
	'sugarcrm' => {
		'dsn'		=> 'DBI:mysql:database=sugarcrm;host=mysql2.adm.netways.de;port=3306;mysql_enable_utf8=1',
		'username'	=> 'icinga-rt',
		'password'	=> 'rm9QsrnRf8ZRbH936IoW',
		'autoconnect'	=> 1
	}
});

# Queries
Set ($DBCustomField_Queries, {
	# Companies from SugarCRM
	'companies' => {
		# The connection to use
		'connection' => 'sugarcrm',

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
	}
});

# Query to CF mapping
Set($DBCustomField_Fields, {
	'Client' => 'companies'
});
