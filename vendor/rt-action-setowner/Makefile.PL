use inc::Module::Install;

RTx     'RT-Action-SetOwner';
license 'gpl_2';
repository 'https://github.com/NETWAYS/rt-extension-action-setowner';
readme_from 'lib/RT/Action/SetOwner.pm';

requires_rt '4.2';

&WriteAll;
