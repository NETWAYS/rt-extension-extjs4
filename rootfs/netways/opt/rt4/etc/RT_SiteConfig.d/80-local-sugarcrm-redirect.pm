# Added a local modification to redirect global id's to sugar UUID

# Location: local/html/NoAuth/SugarCrmRedirector
# Based on this example: https://discourse.netways.de/t/sugarcrm-soap-schnittstelle/208
# Call is: https://rt.netways.de/NoAuth/SugarCrmRedirector?globalId=__CustomField__

Set($NETWAYS_SugarCrm_User, 'netbot');
Set($NETWAYS_SugarCrm_Pass, '5RrdYxY66SM');
Set($NETWAYS_SugarCrm_Base, 'https://sugar.int.netways.de');