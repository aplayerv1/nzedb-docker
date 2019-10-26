FROM ubuntu:16.04
LABEL maintainer "Grimeton (Grimages) <grimages@fullmesh.de>"
ARG S6_VERSION="v1.19.1.1"
ARG S6_ARCH="amd64"
ARG DEBIAN_FRONTEND="noninteractive"
ARG LANG="en_US.UTF-8"
ARG LC_ALL="C.UTF-8"
ARG LANGUAGE="en_US.UTF-8"
ARG TERM="xterm-256color"
RUN apt-get install software-properties-common; apt-add-repository -y ppa:ondrej/php
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils locales\
    && DEBIAN_FRONTEND=noninteractive apt-get -y install \
        curl \
        ffmpeg \
        gettext-base \
        git \
        libtext-micromason-perl \
        mediainfo \
        nginx-extras \
        p7zip-full \
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
        php-pear \
        tzdata \
        unrar \
    && locale-gen $LANG
ADD "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.gz" "/tmp/s6.tar.gz"
RUN tar xfz /tmp/s6.tar.gz -C /
RUN apt-get clean \
    && rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*
EXPOSE 80 443
HEALTHCHECK NONE
COPY rootfs/ /
ENTRYPOINT ["/init"]
