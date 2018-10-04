use warnings FATAL => 'all';
use strict;

use inc::Module::Install;

RTx     'RT-Extension-PretixApi';
license 'gpl_2';
repository 'https://github.com/NETWAYS/rt-extension-pretixapi';

requires_rt '4.2.0';
rt_too_new '4.6.0';

requires(
    'Storable',
    'Cache::FileCache',
    'LWP::UserAgent',
    'HTTP::Request',
    'JSON::MaybeXS',
    'Text::Template'
);

auto_install();

no_index directory => 't';

sign;
WriteAll;
