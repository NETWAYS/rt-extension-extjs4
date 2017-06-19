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
  rt4/rt4netways
