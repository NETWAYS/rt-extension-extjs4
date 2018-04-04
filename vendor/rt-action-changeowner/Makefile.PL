use inc::Module::Install;

RTx     'RT-Action-ChangeOwner';
license 'gpl_2';
repository 'https://github.com/NETWAYS/rt-action-changeowner';
readme_from 'lib/RT/Action/ChangeOwner.pm';

requires_rt '4.2';

&WriteAll;
