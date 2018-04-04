Plugin('RTx::Actitime');

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
