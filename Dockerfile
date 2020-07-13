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
      nano
RUN cd /tmp && wget http://launchpadlibrarian.net/339874908/libav-tools_3.3.4-2_all.deb && dpkg -i libav-tools_3.3.4-2_all.deb
RUN apt-get update
ADD "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.gz" "/tmp/s6.tar.gz" 
RUN tar xfz /tmp/s6.tar.gz -C /
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
ENTRYPOINT ["/init"]
