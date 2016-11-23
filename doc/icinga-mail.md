# Icinga Mail

## Allgemein

Dieses Dokument beschreibt die Verbindung des Mail Systems zwischen des Icinga
Mail Servers (icinga-mail.icinga.netways.de, nachfolgend icinga-mail genannt) und der RT
Instanz (icinga-rt.icinga.netways.de, nachfolgend rt genannt).

## Grundlegender Workflow

Der in Erscheinung tretende MTA ist auf icinga-mail eingerichtet. Alle eingehenden
Mails werden durch diesen Postfix angenommen. Augehend sendend tritt allerdings
der rt in Kraft. Alle Mails aus dem RT werden auch vom rt versendet.

## Transport Mapping auf icinga-mail

    # cat /etc/postfix/transport
    info@icinga.com local:
    
    rt.icinga.com   smtp:rt.icinga.com:25
    .rt.icinga.com  smtp:rt.icinga.com:25
    # postmap /etc/postfix/transport && postfix reload
    postfix/postfix-script: refreshing the Postfix mail system

Alle eingehenden Mails auf web, welche als Zieladresse den rt haben (oder
Subdomains des rt's), werden per SMTP transport auf den Server direkt
weitergeleitet.

## Virtual Mapping auf web

    # grep '\s*@rt\.icinga\.com' /etc/postfix/virtual
    rt@icinga.com                       rt@rt.icinga.com
 
## Virtual Mapping auf rt

    # cat rootfs/icinga/etc/postfix/virtual
    rt@rt.icinga.com        icinga-rt
    rtx@rt.icinga.com       icinga-rtx

## Alias file auf rt

    $ cat rootfs/icinga/etc/aliases
    # See man 5 aliases for format
    postmaster:    root
    
    # TICKET ID
    icinga-rt:  |"/opt/rt4/bin/rt-mailgate
            --extension ticket
            --queue 'General'
            --action correspond
            --url http://localhost"
    
    icinga-xrt: |"/opt/rt4/bin/rt-mailgate
            --extension ticket
            --queue 'General'
            --action comment
            --url http://localhost"

