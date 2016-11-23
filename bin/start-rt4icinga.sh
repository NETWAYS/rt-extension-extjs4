#!/bin/bash
docker run \
  --name=rt4icinga \
  --hostname=rt.icinga.com \
  --privileged=true \
  --restart=always \
  -d \
  -p 25:25 \
  -p 80:80 \
  -p 443:443 \
  rt4/rt4icinga
