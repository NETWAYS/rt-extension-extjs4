# Calendar Invitations for Request Tracker

## About

If enabled, this extension allows calendar invitations to be distributed by RT:

 * Mime type text/calendar declared as possible content type for RT (frontend)
 * The mime/alternative invitation mail will be used when RT adds attachments to mail action
 

## License

This project is licensed under the terms of the GNU General Public License Version 2.

This software is Copyright (c) 2018 by NETWAYS GmbH <[support@netways.de](mailto:support@netways.de)>.

## Support

For bugs and feature requests please head over to our [issue tracker](https://github.com/NETWAYS/rt-extension-calendarinvitation/issues).
You may also send us an email to [support@netways.de](mailto:support@netways.de) for general questions or to get technical support.

## Requirements

- RT 4.4.2

## Installation

Extract this extension to a temporary location.

Git clone:

```
git clone https://github.com/NETWAYS/rt-extension-calendarinvitation
cd /usr/local/src
```

Tarball download (latest [release](https://github.com/NETWAYS/rt-extension-calendarinvitation/releases/latest)):

```
cd /usr/local/src
wget https://github.com/NETWAYS/rt-extension-calendarinvitation/archive/master.zip
unzip master.zip
```

Navigate into the source directory and install the extension.

```
perl Makefile.PL
make
make install
```

Clear your mason cache.

```
rm -rf /opt/rt4/var/mason_data/obj
```

Restart your web server.

```
systemctl restart httpd

systemctl restart apache2
```

## Configuration

No configuration is needed.