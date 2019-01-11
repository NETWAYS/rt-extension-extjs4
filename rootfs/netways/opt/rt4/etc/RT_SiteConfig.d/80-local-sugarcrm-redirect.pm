# Added a local modification to redirect global id's to sugar UUID

# Location: local/html/NoAuth/SugarCrmRedirector
# Based on this example: https://discourse.netways.de/t/sugarcrm-soap-schnittstelle/208
# Call is: http://10.211.55.32/NoAuth/SugarCrmRedirector?globalId=10533

Set($NETWAYS_SugarCrm_User, 'netbot');
Set($NETWAYS_SugarCrm_Pass, '5RrdYxY66SM');
Set($NETWAYS_SugarCrm_Base, 'https://sugar.int.netways.de');