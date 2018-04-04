FROM rt4/runtime

ARG RT_SOURCE

ENV RTHOME ${RTHOME:-/opt/rt4}
ENV RT_SOURCE ${RT_SOURCE:-/opt/rt4-build/src}
ENV GNUPGHOME ${GNUPGHOME:-/opt/rt4/var/data/gpg}

VOLUME /var/log/request-tracker

COPY ./vendor $RT_SOURCE
COPY ./rootfs/netways/ /

RUN chmod 755 /opt/rt4/etc/RT_SiteConfig.pm \
  && chown root.rt /opt/rt4/etc/RT_SiteConfig.pm \
  && mkdir -p /var/log/request-tracker \
  && chown root.rt -R /opt/rt4/etc/RT_SiteConfig.d \
     /var/log/request-tracker

RUN rt4-install-extensions.sh \
  rt-action-changeowner \
  rt-action-setowner \
  rt-extension-actitime \
  rtx-addservicedata \
  rt-extension-create-external \
  rtx-createlinkedtickets \
  rtx-dbcustomfield \
  rt-extension-emailheader \
  rtx-extjs4 \
  rt-extension-historycomponent \
  rt-extension-netways \
  rt-extension-queuecategories \
  rtx-ticketactions \
  rt-extension-updatehistory \
  rt-extension-usersearch \
  RT-Extension-ExtractCustomFieldValues \
  rtx-action-subjectandevent

RUN sed -i -e "s/localhost\.localdomain/`cat /etc/mailname`/g" /etc/postfix/main.cf

RUN /usr/local/sbin/update-postfix-tables.sh

EXPOSE 25 80 443

