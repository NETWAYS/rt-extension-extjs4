# Queue Categories Extension for Request Tracker

#### Table of Contents

1. [About](#about)
2. [License](#license)
3. [Support](#support)
4. [Requirements](#requirements)
5. [Installation](#installation)
6. [Configuration](#configuration)

## About

Provides queue grouping by categories for

- Ticket creation drop-down

![Create new ticket](doc/new-ticket.png)

- Dashboard element

![Queues stats](doc/stats.png)

## License

This project is licensed under the terms of the GNU General Public License Version 2.

This software is Copyright (c) 2018 by NETWAYS GmbH <[support@netways.de](mailto:support@netways.de)>.

## Support

For bugs and feature requests please head over to our [issue tracker](https://github.com/NETWAYS/rt-extension-queuecategories/issues).
You may also send us an email to [support@netways.de](mailto:support@netways.de) for general questions or to get technical support.

## Requirements

- RT 4.4.2

## Installation

Extract this extension to a temporary location.

Git clone:

```
cd /usr/local/src
git clone https://github.com/NETWAYS/rt-extension-queuecategories
```

Tarball download (latest [release](https://github.com/NETWAYS/rt-extension-queuecategories/releases/latest)):

```
cd /usr/local/src
wget https://github.com/NETWAYS/rt-extension-queuecategories/archive/v1.0.0.zip
unzip v1.0.0.zip
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

1. Create a custom field `QueueCategory` of type `Select one value`.
2. Add the desired categories as values and specify their sort order.
3. Apply it to all queues (globally).
4. Edit each queue to be categorized and set `QueueCategory` as desired.

### Custom order

Categories are sorted by the sort order of the custom field's value for `QueueCategory`.
Queues are sorted by their own sort order.
Both of them fall back to alphabetical order.

### Custom field customization

The custom field's name isn't limited to `QueueCategories`.
An alternative name can be configured in RT configuration file:

```
Plugin('RT::Extension::QueueCategories');

Set($QueCat_CF, 'MyQueueCategory');
```
