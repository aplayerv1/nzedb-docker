FROM ubuntu:16.04
LABEL maintainer "Aplayerv1"
ARG S6_VERSION="v1.19.1.1"
ARG S6_ARCH="amd64"
ARG DEBIAN_FRONTEND="noninteractive"
ARG LANG="en_US.UTF-8"
ARG LC_ALL="C.UTF-8"
ARG LANGUAGE="en_US.UTF-8"
ARG TERM="xterm-256color"
RUN apt-get update \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C \
    && echo "deb http://ppa.launchpad.net/nginx/development/ubuntu xenial main" >> /etc/apt/sources.list \
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y -q --no-install-recommends \
      ca-certificates \
      nginx \
      gettext-base \
      git \
      php-pear \
      php7.1 \
      php7.1-cgi \
      php7.1-cli \
      php7.1-common \
      php7.1-curl \
      php7.1-gd \
      php7.1-json \
      php7.1-mysql \
      php7.1-readline \
      php7.1-recode \
      php7.1-tidy \
      php7.1-xml \
      php7.1-xmlrpc \
      php7.1-bcmath \
      php7.1-bz2 \
      php7.1-dba \
      php7.1-fpm \
      php7.1-intl \
      php7.1-mbstring \
      php7.1-mcrypt \
      php7.1-soap \
      php7.1-xsl \
      php7.1-zip \
	  php-imagick \
	  mysql-client \
	  unrar \
	  p7zip-full \
	  mediainfo \
	  lame \
	  ffmpeg \
	  libav-tools \
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
	  screen
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
HEALTHCHECK NONE
COPY rootfs/ /
RUN chmod +x -R /opt/scripts
ENTRYPOINT ["/init"]
