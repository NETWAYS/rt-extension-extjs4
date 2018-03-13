use inc::Module::Install;

RTx     'RT-Extension-Netways';
license 'gpl_2';
repository 'https://git.netways.org/rt4/rt-extension-netways';

requires_rt '4.4.2';

sign;
WriteAll;
