# NETWAYS Docker Environment

Specs:

    Begin:               2015-11-19    
    Version:             1.1.0 (2016-08)
    RT Version:          4.2.1 (2016-08-09)


## Allgemein

Die Dockerumgebung (rt4netways) beinhaltet einen Satz von Images und
Konfigurationen welche produktive Laufzeitumgebungen für den RequestTracker
beinhalten.

## Abhängigkeiten

Zum Betrieb sind folgende Werkzeuge erforderlich:

* make ```(deprecared)```
* docker ```1.10.0+```
* docker-compose ```1.6.0+```

> **Achtung:** Seit August 2016 wurde der Kit auf Version 2 des Konfigformates
> umgestellt. Die Imagenamen, Dockerfiles und Compose-Services sind
> untereinander nicht mehr kompatibel. Container, Images und andere Abhängigkeiten
> müssen neu erstellt werden.

## Kurzanleitung

    # Bau der Basis images
    make base-images
    # Bau der Icinga Instanz
    make icinga
    # Manueller Bau einzelner Images
    make base library source runtime icinga

## Schichtung der Docker-Images

Die Docker-Images gliedern sich in einzelne Schichten. Dadurch muss nicht immer
das vollständige Image gebaut werden sondern z.B. die Perl Library einzeln
gebaut werden.

Folgende Images werden von Compose erstellt:

### Build Helper

| Image      | Beschreibung |
|------------|--------------|
| ```rt4/base``` | Grundsystem, Installation von Tools und bereitstellen von System Upgraeds. |
| ```rt4/library``` | Perl Bibliotheken werden mit Hilfe von Debian Repos und CPAN installiert. |
| ```rt4/source``` | RT Source Code wird konfguriert, installiert. Ab diesem Image ist der RT läuffähig. |
| ```rt4/runtime``` | Apache2, Postfix, Cron werden konfiguriert und dem Supervisor im Vordergrund gestartet. |

### Produktiv-Images

Diese Images können direkt gestartet werden und beherbergen Ihre eigene
Konfiguration

| Image      | Beschreibung |
|------------|--------------|
| ```rt4/rt4icinga``` | RT für Icinga: https://rt.icinga.org |
| ```rt4/netways``` | RT für Icinga: https://rt.icinga.org |
| ```rt4/devkit``` | Entwicklungsumgebung, Perl embedded Webserver und SQLite. |

## Init System

Als Init System wird supervisor verwendet welcher alle Dienste im Vordergrund
startet. Dadurch lassen sich die Logausgaben auf einer Konsole mitverfolgen.
Eine Ausnahme bildet hier Postfix, da dieser eine Reihe von Diensten
(qmgr, pickup) selber startet.

Der supervisor-Dienst ist so eingerichtet, dass man mittels `supervisorctl`
den Unix-Socket ansprechen kann. So ist es innerhalb des Docker-Containers
möglich, etwa `apache2` neuzustarten um RT-Perl-Module zu laden.

    supervisorctl status apache2
    supervisorctl restart apache2

## Docker Build Hinweis

Das Docker Workdir ist auf `./` angelegt. Die einzelnen Images liegen
allerdings in Einzeldateien im Verzeichnis `./docker`.

Mit der Syntax Version 2 von  `docker-compose` können nun die typischen
Namespaces verwendet werden. Baut man alle verfügbaren Images erhält man
folgende Liste:

```
# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
rt4/rt4devkit       latest              d2e03d386dbc        About a minute ago   888.9 MB
rt4/rt4icinga       latest              0676b893a07f        2 minutes ago        1.186 GB
rt4/rt4netways      latest              775cc1d40779        3 minutes ago        1.186 GB
rt4/runtime         latest              111722496211        5 minutes ago        969.1 MB
rt4/source          latest              82b04d541834        7 minutes ago        888.9 MB
rt4/library         latest              5c255e404b59        8 minutes ago        606 MB
rt4/base            latest              6a6daef8e054        17 minutes ago       327.4 MB
````

## RootFS

Das Dateisystem ist unter `./rootfs` aufgehängt, beinhaltet allerdings eine
Unterscheidung zwischen generische und spezifischen Dateien.

Das Verzeichnis `./rootfs/generic` beinhaltet alle allgemeinen Dateien, welche
für den Betrieb erforderlich sind. Diese Dateien können allerdings von
spezifischen Images überschrieben werden.

*Wichtig*: Die spezifischen Images (icinga und netways) kopieren keine
Einzeldateien mehr sondern den kompletten Root Tree:

    COPY ./rootfs/netways /

### Postfix

Bei Postfix ist ein Großteil der Konfiguration in Einzeldateien ausgelagert
(z.B. mydestination,  mynetworks). Dadurch muss nicht die komplette Postfix
Konfiguration überschrieben werden.

*Wichtig*: `/etc/mailname`muss existieren und `myhostname` innerhalb der
`main.cf` mit dem Wert `localhost.localdomain` vorhanden sein. Dieser Wert
wird durch den Inhalt von `/etc/mailname` ausgetauscht.

## Vendor

Innerhalb von `./vendor` sind alle verwendeten Sourcen per git-subtree
eingebunden. Da es sich hierbei um eine große Menge handelt, kann eine
Eintragung der Remotes und Aktualisierungen über `./bin/setup-git.sh`
vorgenommen werden.

Das Verzeichnis wird im Zielsystem unter `/opt/rt4-build/src` aufgehängt.

## Tools

Um den Build Vorgang zu vereinfachen werden auf die Zielsysteme eine Hand
voll Scripts kopiert:

### cpanfile

Unter `/opt/rt4-build/cpanfile` sind für `cpanminus` alle Perl Abhängigkeiten
gelistet.

### rt4-install-extensions.sh

Ebenfalls unter rt4-build kann mit diesem Script auf die RT Instanz
(`/opt/rt4`) Plugins installiert werden. Die Plugins müssen in
`/opt/rt4-build/src` als Perl Module vorhanden sein.

*Beispiel*:

    RUN rt4-install-extensions.sh rtx-action-setowner rtx-addservicedata

### update-postfix-tables.sh
Das Script unter `/usr/local/sbin` aktualisiert alle Postfix Hash Tables und
führt einen `postfix reload` durch.

## Start der Instanz

### Start der NETWAYS Instanz

Bezogen auf ein NETWAYS Single-Machine Docker Environment gestaltet sich der
Start des RT folgendermaßen:

    docker run \
      --name=rt4netways \
      --hostname=rt.netways.de \
      --privileged=true \
      -d \
      -p 25:25 \
      -p 80:80 \
      -p 443:443 \
      rt4/rt4netways

### Start der Icinga Instanz

Bezogen auf ein NETWAYS Single-Machine Docker Environment gestaltet sich der
Start des RT für Icinga folgendermaßen:

    docker run \
      --name=rt4icinga \
      --hostname=rt.icinga.org \
      --privileged=true \
      -d \
      -p 25:25 \
      -p 80:80 \
      -p 443:443 \
      rt4netways/rt4icinga

## Updates

### RT Version aktualisieren

* Feature-Branch erstellen, RT 4.2 -> RT 4.4 Upgrade
* Container starten, aber nicht als Daemon mit Produktiv-Datenbank (!)

Auf speziellen Port binden und RT anpassen:

    docker run -ti -p 30000:30000 rt4netways_netways bash

    cd /opt/rt4

    vim etc/RT_SiteConfig.pm

    Set($WebDomain, 'localhost');
    Set($WebPath, "");
    Set($WebPort, 30000);

Produktions-Datenbank auskommentieren (RT verwendet dann eine lokale SQLite-Instanz).

    #Set($DatabaseType, "mysql");
    #Set($DatabaseHost,   "mysql1.adm.netways.de");
    #Set($DatabaseUser, "rt4_user");
    #Set($DatabasePassword, q{xxxxxxxxxx});
    #Set($DatabaseName, "rt4_net_support");

Log-Level auf "debug" setzen.

    Set($LogToSTDERR, "debug");

Cache leeren und RT-Server starten.

    rm -rf /opt/rt4/var/mason_data/*
    /opt/rt4/sbin/rt-server

#### RT-Plugins hinzufügen

    cd /opt/rt4-build/src/rtx-action-changeowner
    make initdb
    (leeres Passwort, Enter)

    /opt/rt4/sbin/rt-server

#### Funktionalität überprüfen

https://localhost:3000 (root/password)

* RT-Plugins
* Scripts


### Plugins aktualisieren

Die jeweiligen RT-Plugins sind als Git-Subtree in das Hauptrepository eingebunden.
Um ein Update der Quellen in `vendor/` vorzunehmen, müssen die externen Repositories
als zusätzliche Remotes eingetragen werden.

    ./bin/setup-git.sh

Um ein bestimmtes Plugin zu aktualisieren, muss man den Subtree pullen und squashen.

    git subtree pull --prefix vendor/rtx-action-subjectandevent rtx-action-subjectandevent master --squash

Git-Log kontrollieren und die Änderungen pushen.

    git push

### RT Container Upgrade

Per SSH auf die Produktiv-Instanz connection (mit `-A`) und in nach `/home/rt/rt4netways`
wechseln. Dort das Git-Repository pullen.

    ssh -A mfriedrich@net-rt.adm.netways
    cd /home/rt/rt4netways
    sudo git pull

Die Docker-Images neu bauen.

    make base-images
    make netways (oder icinga)

Den laufenden Docker-Container stoppen und löschen.

    docker stop rt4netways
    docker rm rt4netways

Den neuen Docker-Container mittels Start-Script in `/home/rt` starten.

    /home/rt/start-rt4netways.sh


## Weiterführende Dokumentation

Zum Beispiel zur Anbindung der Mailsysteme sind im Verzeichnis `./doc`
untergebracht.

# Appendix

## Links

* [Issue Tracker auf project.netways.de](https://project.netways.de/projects/netrt)
* [Gitlab Projekt auf git.netways.org](https://git.netways.org/groups/RequestTracker)
