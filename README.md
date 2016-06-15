# rt4netways Docker Environment

## Allgemein

Die rt4netways Docker Umgebung beinhaltet einen Satz von Images und
Konfigurationen welche produktive Laufzeitumgebungen für den RequestTracker
beinhalten.

## Abhängigkeiten

Zum Betrieb sind folgende Werkzeuge erforderlich:

* Make
* docker
* docker-compose

## Kurzanleitung

    # Bau der Basis images
    make base-images
    # Bau der Icinga Instanz
    make icinga
    # Manueller Bau einzelner Images
    make base library source runtime icinga

## Schichtung der Docker-Images

Die Docker-Images gliedern sich in folgende Einzelschichten

### base

Grundsystem, Installation von Tools, setzen der Zeitzone und LANG Konstanten.

### library

Vorbereiten des Systems auf ein RT Build Environment und Installation der
Abhängigkeiten.

### source

Kopieren der Sourcen und Modulen auf das System, Source vorbereiten und
Installation eines Standalone RT Systems mit SQLite und PLACK Standalone
Webserver.

### runtime

Aufblasen des Images auf ein Produktivsystem durch die Installation von Cron,
RSyslog, Apache und Postfix.

### Produktiv-Images

#### icinga

Produktive Instanz für Icinga mit entfernten MySQL Server.

#### netways

Produktive Instanz für NETWAYS mit entfernten MySQL Server.

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

Mit `docker-compose` werden die Images mit einem Prefix versehen. Das Image
für Icinga erhält also den Namen: `rt4netways_icinga`.

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
      rt4netways_netways

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
      rt4netways_icinga

## Updates

### Plugins aktualisieren

Die jeweiligen RT-Plugins sind als Git-Subtree in das Hauptrepository eingebunden.
Um ein Update der Quellen in `vendor/` vorzunehmen, müssen die externen Repositories
als zusätzliche Remotes eingetragen werden.

    ./bin/setup-git.sh

Um ein bestimmtes Plugin zu aktualisieren, muss man den Subtree pullen und squashen.

    git subtree pull --prefix vendor/rtx-action-subjectandevent rtx-action-subjectandevent master --squash

Git-Log kontrollieren und die Änderungen pushen.

    git push

Gitlab-Repository aktualisieren:

    git remote add gitlab git@gitlab.netways.org:RequestTracker/rt4netways.git
    git push gitlab master

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

