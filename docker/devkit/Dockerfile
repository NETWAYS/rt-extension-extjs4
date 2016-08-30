FROM rt4/source

ARG RT_SOURCE

ENV RT_SOURCE ${RT_SOURCE:-/opt/rt4-build/src}
ENV RTHOME ${RTHOME:-/opt/rt4}

WORKDIR /opt/rt4

COPY ./rootfs/devkit/usr/local/bin/docker-entrypoint.sh \
  /usr/local/bin/docker-entrypoint.sh
COPY ./rootfs/devkit/opt/rt4/etc/RT_SiteConfig.d/devkit.pm \
  /opt/rt4/etc/RT_SiteConfig.d/devkit.pm

RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

VOLUME /opt/rt4/local/po
VOLUME /opt/rt4/local/lib
VOLUME /opt/rt4/local/html
VOLUME /opt/rt4/local/static
VOLUME /opt/rt4/local/plugins
VOLUME /opt/rt4/local/etc
VOLUME /opt/rt4/var

EXPOSE 8080

CMD ["/usr/local/bin/docker-entrypoint.sh"]
