#!/bin/bash
docker run \
  --name=rt4icinga \
  --hostname=rt.icinga.org \
  --privileged=true \
  -d \
  -p 25:25 \
  -p 80:80 \
  -p 443:443 \
  -p 8080:8080 \
  -e "LANG=de_DE.UTF-8" \
  -e "LC_ALL=de_DE" \
  -v /home/rt/rt4-mason-data:/opt/rt4/var/mason_data \
  -v /home/rt/rt4-session-data:/opt/rt4/var/session_data \
  -v /home/rt/postfix-spool:/var/spool/postfix \
  net-docker-registry.adm.netways.de:5000/rt4/rt4icinga
