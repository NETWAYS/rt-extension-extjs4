use inc::Module::Install;

RTx     'RT-Extension-DBCustomField';
license 'gpl_2';
repository 'https://github.com/NETWAYS/rt-extension-dbcustomfield';

requires_rt '4.4.2';
requires 'DBI' => '1.37';

sign;
WriteAll;
