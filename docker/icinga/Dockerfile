FROM rt4/runtime

ARG RT_SOURCE

ENV RT_SOURCE ${RT_SOURCE:-/opt/rt4-build/src}
ENV RTHOME ${RTHOME:-/opt/rt4}

COPY ./rootfs/icinga/ /

RUN chmod 755 /opt/rt4/etc/RT_SiteConfig.pm \
  && chown root.rt /opt/rt4/etc/RT_SiteConfig.pm \
  && chmod 755 /usr/local/sbin/icinga-cron-resolve-automails.sh

RUN rt4-install-extensions.sh \
  rtx-action-setowner \
  rtx-addservicedata \
  rtx-create-external \
  rtx-createlinkedtickets \
  rtx-dbcustomfield \
  rtx-emailheader \
  rtx-extjs4 \
  rtx-historycomponent \
  rtx-netways \
  rtx-queuecategories \
  rtx-ticketactions \
  rtx-updatehistory \
  rtx-usersearch \
  rtx-action-changeowner \
  RT-Extension-ExtractCustomFieldValues

RUN sed -i -e "s/localhost\.localdomain/`cat /etc/mailname`/g" /etc/postfix/main.cf

RUN /usr/local/sbin/update-postfix-tables.sh

EXPOSE 25 80 443
