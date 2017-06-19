# base machine
FROM debian:jessie

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ
ARG LANG

ENV DEBIAN_FRONTEND ${DEBIAN_FRONTEND:-noninteractive}
ENV TZ ${TZ:-UTC}
ENV LANG ${LANG:-C}

COPY ./rootfs/generic/etc/apt/sources.list /etc/apt/sources.list

RUN apt-get update \
  && apt-get dist-upgrade -u -y \
  && apt-get install -y --no-install-recommends \
    apt-utils \
    autoconf \
    build-essential \
    locales \
    locales-all \
    && rm -rf /var/lib/apt/lists/*

RUN echo $TZ > /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata

RUN dpkg-reconfigure locales && \
  locale-gen $LANG && \
  /usr/sbin/update-locale LANG=$LANG

CMD ["/bin/bash"]
