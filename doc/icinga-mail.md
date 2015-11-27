# Icinga Mail

## Allgemein

Dieses Dokument beschreibt die Verbindung des Mail Systems zwischen des Icinga
Mail Servers (icinga-web.adm.icinga.org, nachfolgend web genannt) und der RT
Instanz (net-icinga-rt.adm.netways.de, nachfolgend rt genannt).

## Grundlegender Workflow

Der in Erscheinung tretende MTA ist auf web eingerichtet. Alle eingehenden
Mails werden durch diesen Postfix angenommen. Augehend sendend tritt allerdings
der rt in Kraft. Alle Mails aus dem RT werden auch vom rt versendet.

## Transport Mapping auf web

    # cat /etc/postfix/transport
    info@icinga.org local:
    
    rt.icinga.org   smtp:rt.icinga.org:25
    .rt.icinga.org  smtp:rt.icinga.org:25
    # postmap /etc/postfix/transport && postfix reload
    postfix/postfix-script: refreshing the Postfix mail system

Alle eingehenden Mails auf web, welche als Zieladresse den rt haben (oder
Subdomains des rt's), werden per SMTP transport auf den Server direkt
weitergeleitet.

## Virtual Mapping auf web

    # grep '\s*@rt\.icinga\.org' /etc/postfix/virtual
    rt@icinga.org                       rt@rt.icinga.org
 
## Virtual Mapping auf rt

    # cat rootfs/icinga/etc/postfix/virtual
    rt@rt.icinga.org        icinga-rt
    rtx@rt.icinga.org       icinga-rtx

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

