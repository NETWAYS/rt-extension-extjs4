# RT-Action-SetOwner

#### Table of Contents

1. [About](#about)
2. [License](#license)
3. [Support](#support)
4. [Requirements](#requirements)
5. [Installation](#installation)
6. [Configuration](#configuration)

## About

Scrip action to control the owner of a ticket in two ways.

## License

This project is licensed under the terms of the GNU General Public License Version 2.

This software is Copyright (c) 2018 by NETWAYS GmbH [support@netways.de](mailto:support@netways.de).

## Support

For bugs and feature requests please head over to our [issue tracker](https://github.com/NETWAYS/rt-extension-action-setowner/issues).
You may also send us an email to [support@netways.de](mailto:support@netways.de) for general questions or to get technical support.

## Requirements

- RT 4.2

## Installation

Extract this extension to a temporary location.

Git clone:

    cd /usr/local/src
    git clone https://github.com/NETWAYS/rt-extension-action-setowner

Tarball download:

    cd /usr/local/src
    wget https://github.com/NETWAYS/rt-extension-action-setowner/archive/master.zip
    unzip master.zip

Navigate into the source directory and install the extension. (May need root permissions.)

    perl Makefile.PL
    make
    make install

Edit your `/opt/rt4/etc/RT_SiteConfig.pm`

Add this line:

    Plugin('RT::Action::SetOwner');

Clear your mason cache:

    rm -rf /opt/rt4/var/mason_data/obj

Restart your webserver.

## Configuration

Owner configured by template:

    1. Create new template with name or id of the user,
    2. Create a new script use this action and select your new created
    template as template argument,
    3. Test and have fun!

Owner by scrip argument:

    1. Be a DB admin and connect to your RT database,
    2. Copy the row from Scrip table with the 'ExecModule' 'SetOwner' and
    add new 'Argument' value representing your user and place a new
    description,
    3. Create a new Scrip with your new ScriptAction created above,
    4. Test and have fun!

Nobody user:

    1. Create a new Scrip action with 'Set to nobody' action,
    2. Test and have fun!
