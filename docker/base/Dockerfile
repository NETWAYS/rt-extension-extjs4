# base machine
FROM debian:buster-backports

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ
ARG LANG

ENV DEBIAN_FRONTEND ${DEBIAN_FRONTEND:-noninteractive}
ENV TZ ${TZ:-UTC}
ENV LANG ${LANG:-C}

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
