FROM rt4/library

ARG RT_BUILD_DIR
ARG RT_CONFIG_DIR
ARG RT_SOURCE
ARG RT_PREFIX
ARG RT_VERSION

ENV RT_PREFIX ${RT_PREFIX:-/opt/rt4}
ENV RT_BUILD_DIR ${RT_BUILD_DIR:-/opt/rt4-build}
ENV RT_CONFIG_DIR $RT_CONFIG_DIR:-/opt/rt4-build/conf.d}
ENV RT_SOURCE ${RT_SOURCE:-/opt/rt4-build/src}
ENV RT_VERSION ${RT_VERSION:-rt-4.4.1}

COPY ./vendor $RT_SOURCE
COPY ./rootfs/generic/usr/local/sbin/rt4-install-extensions.sh \
  /usr/local/sbin/rt4-install-extensions.sh

RUN chmod 755 /usr/local/sbin/rt4-install-extensions.sh
RUN addgroup --system rt && adduser root rt

RUN echo $RT_VERSION > /opt/rt4-build/VERSION \
  && cp -f /opt/rt4-build/VERSION $RT_SOURCE/rt/.tag \
  && ln -sF /bin/false /usr/local/bin/git

RUN cd $RT_SOURCE/rt \
    && autoconf -f \
    && sh configure \
      --prefix=${RT_PREFIX} \
      --enable-graphviz \
      --enable-gd \
      --enable-gpg \
      --enable-smime \
      --enable-externalauth \
      --with-web-handler=modperl2,standalone \
      --with-db-type=SQLite \
      && make install \
      && /usr/bin/perl \
        -I/opt/rt4/local/lib \
        -I/opt/rt4/lib \
        sbin/rt-setup-database \
          --action init \
          --force --dba="" \
          --dba-password=""

RUN mkdir -p $RT_PREFIX/var/data/gpg \
  && chown 33.33 $RT_PREFIX/var/data/gpg \
  && mkdir -p $RT_PREFIX/var/data/smime \
  && chown 33.33 $RT_PREFIX/var/data/smime \
  && mkdir -p $RT_PREFIX/var/data/RT-Shredder \
  && chown 33.33 $RT_PREFIX/var/data/RT-Shredder
