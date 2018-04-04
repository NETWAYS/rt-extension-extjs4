# RT-Extension-HistoryComponent

#### Table of Contents

1. [About](#about)
2. [License](#license)
3. [Support](#support)
4. [Requirements](#requirements)
5. [Installation](#installation)

## About

RT already got a way to see recently viewed tickets. However, it's buried underneath three main menu levels
and easy to miss.

This extension provides a simple portlet that looks no other than any other ticket-list portlet. But it moves
the ticket listing from the mentioned main menu to a more visible and accessible location on "RT at a glance".

No configuration required.

![History Component](doc/screenshot/component.jpg)

## License

This project is licensed under the terms of the GNU General Public License Version 2.

This software is Copyright (c) 2018 by NETWAYS GmbH [support@netways.de](mailto:support@netways.de).

## Support

For bugs and feature requests please head over to our [issue tracker](https://github.com/netways/rt-extension-historycomponent/issues).
You may also send us an email to [support@netways.de](mailto:support@netways.de) for general questions or to get technical support.

## Requirements

- RT 4.4.2

## Installation

Extract this extension to a temporary location.

Git clone:

    cd /usr/local/src
    git clone https://github.com/netways/rt-extension-historycomponent

Tarball download:

    cd /usr/local/src
    wget https://github.com/NETWAYS/rt-extension-historycomponent/archive/master.zip
    unzip master.zip

Navigate into the source directory and install the extension. (May need root permissions.)

    perl Makefile.PL
    make
    make install

Edit your `/opt/rt4/etc/RT_SiteConfig.pm`

Add this line:

    Plugin('RT::Extension::HistoryComponent');

Clear your mason cache:

    rm -rf /opt/rt4/var/mason_data/obj

Restart your webserver.
