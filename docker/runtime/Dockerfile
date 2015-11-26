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
COPY ./rootfs/generic/etc/apache2/ssl/ /etc/apache2/ssl/
COPY ./rootfs/generic/etc/apache2/conf-available/netways-ldap.conf /etc/apache2/conf-available/netways-ldap.conf
COPY ./rootfs/generic/etc/ldap/ldap.conf /etc/ldap/ldap.conf
COPY ./rootfs/generic/etc/cron.d/rt4-cron /etc/cron.d/rt4-cron

COPY ./rootfs/generic/etc/postfix/main.cf /etc/postfix/main.cf
COPY ./rootfs/generic/etc/postfix/canonical /etc/postfix/canonical
COPY ./rootfs/generic/etc/postfix/header_checks /etc/postfix/header_checks
COPY ./rootfs/generic/etc/postfix/virtual /etc/postfix/virtual
COPY ./rootfs/generic/etc/mailname /etc/mailname
COPY ./rootfs/generic/etc/aliases /etc/aliases

RUN /usr/bin/newaliases \
	&& /usr/sbin/postmap /etc/postfix/canonical \
	&& /usr/sbin/postmap /etc/postfix/virtual

RUN /usr/sbin/adduser www-data rt
RUN /usr/sbin/a2enmod ssl ldap authnz_ldap \
	&& /usr/sbin/a2ensite rt \
	&& /usr/sbin/a2enconf netways-ldap \
	&& /usr/sbin/a2dissite 000-default

CMD ["/usr/bin/supervisord"]
