# Additional Fields For Ticket Query Language

#### Table of Contents

1. [About](#about)
2. [License](#license)
3. [Support](#support)
4. [Requirements](#requirements)
5. [Installation](#installation)
6. [Configuration](#configuration)

## About

This plugin adds a couple of fields to the ticket query language of rt:

### LastUpdater

The ```LastUpdater``` is the reference to the ```LastUpdatedBy```. It gives the
benefit to use user fields of the joined table to query with other operators,
e.g.:

```
LastUpdater.EmailAddress NOT LIKE '@netways.de' and Status = '__Active__'
```

## License

This project is licensed under the terms of the GNU General Public License Version 2.

This software is Copyright (c) 2018 by NETWAYS GmbH <[support@netways.de](mailto:support@netways.de)>.

## Support

For bugs and feature requests please head over to our [issue tracker](https://github.com/NETWAYS/rt-extension-searchfields/issues).
You may also send us an email to [support@netways.de](mailto:support@netways.de) for general questions or to get technical support.

## Requirements

- RT 4.4.2
- RT with MySQL database

## Installation

Extract this extension to a temporary location.

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

```perl
Plugin('RT::Extension::SearchFields');
```
