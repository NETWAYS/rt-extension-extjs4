#!/bin/bash
docker run \
  --name=rt4netways \
  --hostname=rt.netways.de \
  --privileged=true \
  --restart=always \
  -e "LANG=de_DE.UTF-8" \
  -e "LC_ALL=de_DE" \
  -d \
  -p 25:25 \
  -p 80:80 \
  -p 443:443 \
  -v /home/rt/signatur:/signatur \
  -v /home/rt/gpg:/opt/rt4/var/data/gpg \
  -v /home/rt/smime:/opt/rt4/var/data/smime \
  -v /var/log/request-tracker:/var/log/request-tracker
  rt4/rt4netways
