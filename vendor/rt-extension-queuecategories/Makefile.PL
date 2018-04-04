use inc::Module::Install;

RTx     'RT-Extension-QueueCategories';
license 'gpl_2';
repository 'https://github.com/NETWAYS/rt-extension-queuecategories';
readme_from 'lib/RT/Extension/QueueCategories.pm';

requires_rt '4.4.2';

sign;
WriteAll;
