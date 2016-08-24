FROM rt4/runtime

ARG RT_SOURCE

ENV RTHOME ${RTHOME:-/opt/rt4}
ENV RT_SOURCE ${RT_SOURCE:-/opt/rt4-build/src}

COPY ./rootfs/netways/ /

RUN chmod 755 /opt/rt4/etc/RT_SiteConfig.pm \
  && chown root.rt /opt/rt4/etc/RT_SiteConfig.pm

RUN rt4-install-extensions.sh \
  rtx-action-setowner \
  rtx-actitime \
  rtx-addservicedata \
  rtx-create-external \
  rtx-createlinkedtickets \
  rtx-dbcustomfield \
  rtx-emailheader \
  rtx-extjs4 \
  rtx-historycomponent \
  rtx-netways \
  rtx-queuecategories \
  rtx-searchmarker \
  rtx-ticketactions \
  rtx-updatehistory \
  rtx-usersearch \
  RT-Extension-ExtractCustomFieldValues \
  rtx-action-subjectandevent \
  rtx-action-changeowner

RUN sed -i -e "s/localhost\.localdomain/`cat /etc/mailname`/g" /etc/postfix/main.cf

RUN /usr/local/sbin/update-postfix-tables.sh

EXPOSE 25 80 443
