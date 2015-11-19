FROM rt4netways_library

ENV RT_BUILD_DIR  /opt/rt4-build
ENV RT_CONFIG_DIR $RT_BUILD_DIR/conf.d
ENV RT_SOURCE     /opt/rt4-build/src
ENV RT_PREFIX     /opt/rt4
ENV RT_VERSION    rt-4.2.12

COPY ./vendor ${RT_SOURCE}

RUN addgroup --system rt && adduser root rt

RUN echo $RT_VERSION > /opt/rt4-build/VERSION \
  && cp -f /opt/rt4-build/VERSION $RT_SOURCE/rt \
  && ln -sF /bin/false /usr/local/bin/git

RUN cd $RT_SOURCE/rt \
    && autoconf -f \
    && sh configure \
      --prefix=${RT_PREFIX} \
      --enable-graphviz \
      --enable-gd \
      --enable-gpg \
      --enable-smime \
      --with-web-handler=modperl2 \
      --with-db-type=mysql \
      && make install
