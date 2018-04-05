FROM rt4/runtime

ARG RT_SOURCE

ENV RT_SOURCE ${RT_SOURCE:-/opt/rt4-build/src}
ENV RTHOME ${RTHOME:-/opt/rt4}

COPY ./vendor $RT_SOURCE
COPY ./rootfs/icinga/ /

RUN chmod 755 /opt/rt4/etc/RT_SiteConfig.pm \
  && chown -R root.rt /opt/rt4/etc/RT_SiteConfig.pm \
     /opt/rt4/etc/RT_SiteConfig.d \
  && chmod 755 /usr/local/sbin/icinga-cron-resolve-automails.sh

RUN rt4-install-extensions.sh \
  rt-action-setowner \
  rt-action-changeowner \
  rt-extension-addservicedata \
  rt-extension-create-external \
  rt-extension-createlinkedtickets \
  rt-extension-dbcustomfield \
  rt-extension-emailheader \
  rt-extension-historycomponent \
  rt-extension-netways \
  rt-extension-queuecategories \
  rt-extension-ticketactions \
  rt-extension-updatehistory \
  rt-extension-usersearch \
  RT-Extension-ExtractCustomFieldValues

RUN sed -i -e "s/localhost\.localdomain/`cat /etc/mailname`/g" /etc/postfix/main.cf

RUN /usr/local/sbin/update-postfix-tables.sh

EXPOSE 25 80 443
