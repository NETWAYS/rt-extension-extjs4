FROM rt4netways_library

ENV RT_BUILD_DIR  /opt/rt4-build
ENV RT_CONFIG_DIR $RT_BUILD_DIR/conf.d
ENV PATH          $RT_BUILD_DIR/bin:$PATH
ENV RT_SOURCE     /opt/rt4-build/src
ENV RT_PREFIX     /opt/rt4
ENV RT_VERSION    rt-4.4.1

COPY ./vendor ${RT_SOURCE}

COPY ./rootfs/generic/opt/rt4-build/bin/* $RT_BUILD_DIR/bin/

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
      --with-web-handler=modperl2 \
      --with-db-type=SQLite \
      && make install \
      && /usr/bin/perl \
        -I/opt/rt4/local/lib \
        -I/opt/rt4/lib \
        sbin/rt-setup-database \
          --action init \
          --force --dba="" \
          --dba-password=""

RUN mkdir -p /opt/rt4/var/data/gpg \
  && chown 33.33 /opt/rt4/var/data/gpg \
  && mkdir -p /opt/rt4/var/data/smime \
  && chown 33.33 /opt/rt4/var/data/smime \
  && mkdir -p /opt/rt4/var/data/RT-Shredder \
  && chown 33.33 /opt/rt4/var/data/RT-Shredder
