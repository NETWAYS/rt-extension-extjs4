use inc::Module::Install;

RTx     'RT-Extension-Netways';
license 'gpl_2';
repository 'https://git.netways.org/rt4/rt-extension-netways';
readme_from 'lib/RT/Extension/Netways.pm';

requires_rt '4.4.2';

sign;
WriteAll;
