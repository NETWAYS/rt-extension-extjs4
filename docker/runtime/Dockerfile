FROM rt4netways_source

ENV POSTFIX_MAILNAME "rt.localhost"
ENV POSTFIX_MAILER_TYPE "Internet Site"

RUN touch /etc/mailname && echo "$POSTFIX_MAILNAME" > /etc/mailname

RUN echo "postfix postfix/mailname                string  ${POSTFIX_MAILNAME}" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type        select  ${POSTFIX_MAILER_TYPE}" | debconf-set-selections

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
COPY ./rootfs/generic/usr/local/sbin/update-postfix-tables.sh /usr/local/sbin/update-postfix-tables.sh

COPY ./rootfs/generic/etc/postfix/ /etc/postfix/
COPY ./rootfs/generic/etc/aliases /etc/aliases

RUN chmod +x /usr/local/sbin/update-postfix-tables.sh
RUN /usr/local/sbin/update-postfix-tables.sh

RUN /usr/sbin/adduser www-data rt
RUN /usr/sbin/a2enmod ssl ldap authnz_ldap \
	&& /usr/sbin/a2ensite rt \
	&& /usr/sbin/a2enconf netways-ldap \
	&& /usr/sbin/a2dissite 000-default

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisor/conf.d/supervisor.conf"]
