FROM rt4netways_source

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    supervisor \
    postfix \
    cron \
    rsyslog \
    apache2 \
    apache2-mpm-event \
    libapache2-mod-perl2 \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 25 80 443

COPY ./rootfs/generic/etc/supervisor/conf.d/supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY ./rootfs/generic/etc/apache2/sites-available/rt.conf /etc/apache2/sites-available/rt.conf
COPY ./rootfs/generic/etc/apache2/netwaysca_b64.cer /etc/apache2/netwaysca_b64.cer
COPY ./rootfs/generic/etc/apache2/conf-available/netways-ldap.conf /etc/apache2/conf-available/netways-ldap.conf
COPY ./rootfs/generic/etc/ldap/ldap.conf /etc/ldap/ldap.conf
COPY ./rootfs/generic/etc/cron.d/rt4-cron /etc/cron.d/rt4-cron

RUN /usr/sbin/adduser www-data rt
RUN /usr/sbin/a2enmod ssl ldap authnz_ldap; /usr/sbin/a2ensite rt && /usr/sbin/a2enconf netways-ldap

CMD ["/usr/bin/supervisord"]
