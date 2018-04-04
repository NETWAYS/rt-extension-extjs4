Plugin('RT::Extension::Actitime');

Set($Actitime_DisablePool, 0);
Set($Actitime_DB_DSN, 'DBI:mysql:database=actitime;host=mysql2.adm.netways.de;port=3306;mysql_enable_utf8=0');
Set($Actitime_DB_USER, 'reporting');
Set($Actitime_DB_PASS, 'Yee3IeSh');
Set($Actitime_PROJECT_NAME, 'p.name_lower');
Set($Actitime_CUSTOMER_NAME, 'c.name_lower');
Set($Actitime_PROJECT_QUERY, '[netways #%d]: %%');
Set($Actitime_CUSTOMER_QUERY, '%%[%d]%%');
Set($Actitime_CUSTOMER_FIELD_NAME, 'Client');
Set($Actitime_HTTP_URL, 'https://time.netways.de/actitime');
Set($Actitime_BUDGET_WARNING_PERCENT, 60);
Set($Actitime_BUDGET_CRITICAL_PERCENT, 90);
Set($Actitime_TASK_SHOW_ALL, 1);
Set($Actitime_TASK_CONFIGURATION, [{
   'name'      => 'Consulting',
   'active'    => ['vor ort', 'remote'],
   'inactive'  => ['nicht berechenbar'],

   'budget_warning_percent'    => 60,
   'budget_critical_percent'   => 90,
}]);
