# base machine
FROM debian:jessie

ENV DEBIAN_FRONTEND   noninteractive
ENV TZ                Europe/Berlin
ENV LANG              C.UTF-8

COPY ["./rootfs/generic/etc/apt/sources.list", "/etc/apt/sources.list"]

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
        apt-utils \
        autoconf \
        build-essential \
        locales \
    && rm -rf /var/lib/apt/lists/*

RUN echo $TZ > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata

RUN dpkg-reconfigure locales && \
    locale-gen $LANG && \
    /usr/sbin/update-locale LANG=$LANG
