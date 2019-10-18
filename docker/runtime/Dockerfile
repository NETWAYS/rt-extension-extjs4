FROM net-docker-registry.adm.netways.de:5000/rt4/source

ARG POSTFIX_MAILNAME
ARG POSTFIX_MAILER_TYPE

ENV POSTFIX_MAILNAME ${POSTFIX_MAILNAME:-rt.localhost}
ENV POSTFIX_MAILER_TYPE ${POSTFIX_MAILER_TYPE:-'Internet Site'}

RUN touch /etc/mailname && echo "$POSTFIX_MAILNAME" > /etc/mailname
RUN echo "postfix postfix/mailname                string  ${POSTFIX_MAILNAME}" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type        select  ${POSTFIX_MAILER_TYPE}" | debconf-set-selections

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    supervisor \
    postfix \
    cron \
    rsyslog \
    apache2 \
    libapache2-mod-perl2 \
    logrotate \
    nfs-common \
    less \
    vim \
    redis-server \
  && rm -rf /var/lib/apt/lists/*

COPY ./rootfs/generic/etc/supervisor/conf.d/supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY ./rootfs/generic/etc/apache2/ports.conf /etc/apache2/ports.conf
COPY ./rootfs/generic/etc/apache2/sites-available/rt.conf /etc/apache2/sites-available/rt.conf
COPY ./rootfs/generic/etc/apache2/sites-available/status.conf /etc/apache2/sites-available/status.conf
COPY ./rootfs/generic/etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-avilable/mpm_prefork.conf
COPY ./rootfs/generic/etc/apache2/ssl/ /etc/apache2/ssl/
COPY ./rootfs/generic/etc/apache2/conf-available/netways-ldap.conf /etc/apache2/conf-available/netways-ldap.conf
COPY ./rootfs/generic/etc/ldap/ldap.conf /etc/ldap/ldap.conf
COPY ./rootfs/generic/etc/cron.d/rt4-cron /etc/cron.d/rt4-cron
COPY ./rootfs/generic/usr/local/sbin/update-postfix-tables.sh /usr/local/sbin/update-postfix-tables.sh
COPY ./rootfs/generic/etc/redis/redis.conf /etc/redis/redis.conf

COPY ./rootfs/generic/etc/postfix/ /etc/postfix/
COPY ./rootfs/generic/etc/aliases /etc/aliases

RUN chmod +x /usr/local/sbin/update-postfix-tables.sh
RUN /usr/local/sbin/update-postfix-tables.sh

RUN /usr/sbin/adduser www-data rt
RUN /usr/sbin/a2dismod mpm_event
RUN /usr/sbin/a2enmod mpm_prefork ssl ldap authnz_ldap rewrite expires headers status \
	&& /usr/sbin/a2ensite rt status \
	&& /usr/sbin/a2enconf netways-ldap \
	&& /usr/sbin/a2dissite 000-default

EXPOSE 25 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisor.conf"]
