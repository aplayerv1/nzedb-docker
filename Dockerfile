FROM ubuntu:18.04
LABEL maintainer "Aplayerv1"
ARG S6_VERSION="v1.19.1.1"
ARG S6_ARCH="amd64"
ARG DEBIAN_FRONTEND="noninteractive"
ARG LANG="en_US.UTF-8"
ARG LC_ALL="C.UTF-8"
ARG LANGUAGE="en_US.UTF-8"
ARG TERM="xterm-256color"
RUN apt-get update \
    && apt-get install -y gnupg2 wget
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C \
    && echo "deb http://ppa.launchpad.net/nginx/development/ubuntu bionic main" >> /etc/apt/sources.list \
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main" >> /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y -q --no-install-recommends \
      ca-certificates \
      nginx \
      gettext-base \
      git \
      gcc \
      make \
      redis-server \
      php-pear \
      php7.2-fpm \
      php7.2-mysql \
      php7.2-common \
      php7.2-gd \
      php7.2-json \
      php7.2-cli \
      php7.2-curl \
      iputils-ping \
      php7.2-memcached \
      php-imagick \
      php7.2-dev \
      php7.2-mbstring \
      php7.2-xml \
      curl \
      mysql-client \
      unrar \
      p7zip-full \
      mediainfo \
      lame \
      ffmpeg \
      build-essential \
      autotools-dev \
      automake \
      libevent-dev \
      ncurses-dev \
      autotools-dev \
      automake \
      pkg-config \
      python \
      curl \
      time \
      screen \
      software-properties-common \
      nano \
      iproute2 \
      mysql-common \
      libodbc1 \
      unixodbc \
      zlib1g \
      libc6 \
      libstdc++6 \
      libpq5 \
      libmagickwand-dev \
      libmagickcore-dev \
      php-xml
RUN cp /etc/php/8.1/mods-available/imagick.ini /etc/php/7.2/fpm/conf.d/20-imagick.ini && cp /etc/php/8.1/mods-available/imagick.ini /etc/php/7.2/cli/conf.d/20-imagick.ini
RUN printf "\n" | pecl install imagick
RUN cd /tmp && git clone https://github.com/igbinary/igbinary.git && cd igbinary && phpize && ./configure CFLAGS="-O2 -g" --enable-igbinary && make && make test && make install && echo "extension=igbinary.so" > /etc/php/7.2/mods-available/igbinary.ini
RUN cd /tmp && git clone https://github.com/nicolasff/phpredis.git && cd /tmp/phpredis && phpize && ./configure --enable-redis-igbinary && make && make install && echo "extension=redis.so" > /etc/php/7.2/mods-available/redis.ini
RUN cd /tmp && wget http://launchpadlibrarian.net/339874908/libav-tools_3.3.4-2_all.deb && dpkg -i libav-tools_3.3.4-2_all.deb
RUN phpenmod redis && phpenmod igbinary
RUN apt-get update
ADD "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.gz" "/tmp/s6.tar.gz" 
RUN cd /tmp && tar xfz /tmp/s6.tar.gz -C /
RUN apt-get clean \
    && rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*
RUN yes | perl -MCPAN -e 'install Text::MicroMason'
RUN cd /tmp && git clone https://github.com/tmux/tmux.git --branch 2.0 --single-branch && cd tmux/ && ./autogen.sh && ./configure && make -j4 && make install && make clean
EXPOSE 80 443
RUN cd /tmp/ && curl -sS https://getcomposer.org/installer -o composer-setup.php && php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN cd /usr/local/ && mkdir ssl && cd ssl/ && wget  https://curl.haxx.se/ca/cacert.pem && composer config --global cafile "/usr/local/ssl/cacert.pem"
HEALTHCHECK NONE
COPY rootfs/ /
RUN chmod +x -R /opt/scripts
RUN cp /usr/bin/php7.2 /usr/bin/php
ENTRYPOINT ["/init"]
