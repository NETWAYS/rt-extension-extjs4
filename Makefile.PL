use inc::Module::Install;

RTx     'RT-Extension-Netways';
license 'gpl_2';
repository 'https://git.netways.org/rt4/rtx-netways';
version_from 'lib/RT/Extension/Netways.pm';
author_from 'lib/RT/Extension/Netways.pm';

requires_rt '4.4.2';

sign;
WriteAll;
