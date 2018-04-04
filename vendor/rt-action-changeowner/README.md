# RT-Action-ChangeOwner

#### Table of Contents

1. [About](#about)
2. [License](#license)
3. [Support](#support)
4. [Requirements](#requirements)
5. [Installation](#installation)

## About

This scrip action does the following: (Condition is ON RESOLVE)

1. Add the current owner to AdminCc
2. Set the current owner to RT->Nobody

This is intended if the customer replies to the ticket after a couple of
months. If the ticket owner is nobody everbody can own the ticket to
reply to the customer. The origin resolver / owner are also notified to
re-take or assist in case of problems.

## License

This project is licensed under the terms of the GNU General Public License Version 2.

This software is Copyright (c) 2018 by NETWAYS GmbH [support@netways.de](mailto:support@netways.de).

## Support

For bugs and feature requests please head over to our [issue tracker](https://github.com/NETWAYS/rt-action-changeowner/issues).
You may also send us an email to [support@netways.de](mailto:support@netways.de) for general questions or to get technical support.

## Requirements

- RT 4.2

## Installation

Extract this extension to a temporary location.

Git clone:

    cd /usr/local/src
    git clone https://github.com/NETWAYS/rt-action-changeowner

Tarball download:

    cd /usr/local/src
    wget https://github.com/NETWAYS/rt-action-changeowner/archive/master.zip
    unzip master.zip

Navigate into the source directory and install the extension. (May need root permissions.)

    perl Makefile.PL
    make
    make install

Edit your `/opt/rt4/etc/RT_SiteConfig.pm`

Add this line:

    Plugin('RT::Action::ChangeOwner');

Clear your mason cache:

    rm -rf /opt/rt4/var/mason_data/obj

Restart your webserver.
