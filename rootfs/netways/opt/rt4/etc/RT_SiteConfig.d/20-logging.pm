Set($LogToSyslog, "error");
Set($LogToSTDERR, undef);
Set($LogToFile , 'debug'); #Attention! https://rt-wiki.bestpractical.com/wiki/LogsConfig
Set($LogDir, '/var/log/request-tracker');
Set($LogToFileNamed, "rt.log");
Set($LogStackTraces, undef);
