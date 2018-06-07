FROM nouphet/mysql4

ENV PHP_INI_DIR /usr/local/etc/php
RUN mkdir -p $PHP_INI_DIR/conf.d

# persistent / runtime deps / phpize deps
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && apt-get update \
    && apt-get install -y \
       apt-utils \
       autoconf \
       bc \
       bison \
       build-essential \
       bzip2 \
       ca-certificates \
      #  php5-curl \
       file \
       flex \
       g++ \
       gcc \
       git \
       imagemagick \
       libaspell-dev \
       libbz2-dev \
       libc-client2007e-dev \
       libc-dev \
       libcurl4-openssl-dev \
       libfontconfig1-dev \
       libfreetype6-dev \
       libgd2-xpm-dev \
       libgpg-error-dev \
       libjpeg-dev \
       libmagickwand-dev \
       libmcrypt-dev \
       libmcrypt4 \
       libmhash-dev \
      #  libmysqlclient-dev \
       libpng-dev \
       libpq-dev \
       libreadline6-dev \
       librecode0 \
       libsnmp-dev \
       libsqlite3-0 \
       libsqlite3-dev \
       libt1-dev \
       libxml2 \
       make \
      #  mysql-client \
       php5-gd \
      #  php5-mysql \
       libphp-adodb \
       pkg-config \
       re2c \
       uuid-dev \
       vim \
       wget \
       zlib1g-dev \
       apache2 \
       elinks \
       # apache2-prefork-dev \
       apache2-threaded-dev \
       # apache2-bin \
       apache2.2-common \
       --no-install-recommends \
      #  apache2 apache2-prefork-dev \
       graphicsmagick spawn-fcgi \
       && ldconfig \
       && apt-get clean \
       && rm -r /var/lib/apt/lists/*

##<autogenerated>##
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html \
    && chown -R www-data:www-data /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html

# Hotfixes php-4.4
## Install libdb4.6 from lucid
RUN mkdir -p /tmp/install/ \
    && cd /tmp/install \
    && wget http://old-releases.ubuntu.com/ubuntu/pool/universe/d/db4.6/libdb4.6_4.6.21-16_amd64.deb \
    && wget http://old-releases.ubuntu.com/ubuntu/pool/universe/d/db4.6/libdb4.6-dev_4.6.21-16_amd64.deb \
    && echo "2f03a50d72f66d6c6ac976cb0ff1131a  libdb4.6-dev_4.6.21-16_amd64.deb" > md5sums \
    && md5sum -c md5sums \
    && dpkg -i libdb4.6-dev_4.6.21-16_amd64.deb \
               libdb4.6_4.6.21-16_amd64.deb \
    && cd \
    && rm -rf /tmp/install \
    # \
    && mkdir -p /tmp/install/ \
    && cd /tmp/install \
    && wget http://www.ijg.org/files/jpegsrc.v7.tar.gz \
    && tar xzf jpegsrc.v7.tar.gz \
    && cd jpeg-7 \
    && ./configure --prefix=/usr/local --enable-shared --enable-static \
    && make \
    && make install \
    # \
    && cd /tmp/install \
    && wget http://download.savannah.gnu.org/releases/freetype/freetype-2.4.0.tar.gz \
    && tar zxf freetype-2.4.0.tar.gz \
    && cd freetype-2.4.0 \
    && ./configure \
    && make \
    && make install \
    # \
    && cd /tmp/install \
    && wget --no-check-certificate  https://curl.haxx.se/download/archeology/curl-7.12.0.tar.gz \
    && tar zxvf curl-7.12.0.tar.gz \
    && cd curl-7.12.0 \
    && ./configure --without-ssl \
    && make \
    && make install \
    && cd \
    && rm -rf /tmp/install

ENV GPG_KEYS 0B96609E270F565C13292B24C13C70B87267B52D 0BD78B5F97500D450838F95DFE857D9A90D90EC1 F38252826ACD957EF380D39F2F7956BC5DA04B5D
RUN set -xe \
    && for key in $GPG_KEYS; do \
         gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
       done

ENV TZ Asia/Tokyo
ENV HOSTNAME apache22-php440

RUN mkdir -p /tmp/install/
ENV PHP_VERSION 4.4.0
COPY php-${PHP_VERSION}.tar.bz2 /tmp/install/
RUN mkdir -p /tmp/install/ \
    && cd /tmp/install \
    # && wget http://museum.php.net/php4/php-${PHP_VERSION}.tar.bz2 \
    && echo "e85b606fe48198bfcd785e5a5b1c9613  php-${PHP_VERSION}.tar.bz2" > md5sums \
    && md5sum -c md5sums \
    && tar xfj php-${PHP_VERSION}.tar.bz2 \
    && cd php-${PHP_VERSION} \
    && cp /usr/lib/x86_64-linux-gnu/libpng* /usr/lib/ \
    && cd /tmp/install/php-${PHP_VERSION} \
    && ./configure \
        --with-tsm-pthreads \
        --enable-maintainer-zts \
        # --disable-debug \
        --enable-debug \
        --disable-rpath \
        --enable-bcmath \
        --enable-ctype \
        --enable-exif \
        --enable-fastcgi \
        --enable-ftp \
        --enable-gd-native-ttf \
        --enable-inline-optimization \
        --enable-intl \
        --enable-mbregex \
        --enable-mbstring \
        --enable-pcntl \
        --enable-soap  \
        --enable-sockets \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-zip \
        --with-apxs2=/usr/bin/apxs2 \
        --with-bz2 \
        --with-config-file-path=/etc/php4 \
        --with-config-file-path=/etc \
        --with-config-file-scan-dir=/etc/php4/conf.d \
        --with-curl \
        # --with-db4 \
        --with-gettext \
        --with-iconv \
        --with-libdir=lib/x86_64-linux-gnu \
        --with-libxml-dir=/usr \
        --with-mcrypt \
        --with-mhash \
        --with-mysql=/usr/local/mysql \
        --with-mysqli \
        --with-pcre-regex \
        --with-pdo-mysql \
        --with-pgsql \
        --without-snmp \
        --without-sapi \
        --disable-sapi \
        --with-t1lib=/usr \
        --with-tidy \
        # --with-apxs2 \
        # --with-kerberos=/usr \
        --with-gd \
        --with-png-dir=/usr \
        --with-jpeg-dir=/usr \
        --with-freetype-dir=shared,/usr \
        --with-zlib \
        --with-zlib-dir=/usr \
        # --with-gd=shared,/usr/lib  \
        # --with-imap \
        # --with-imap-ssl \
        # --with-ldap \
        # --with-openssl \
        # --with-openssl-dir=/usr/local \
        --with-xsl \
    && make \
    && make install \
    && rm -rf /tmp/install \
    && mkdir -p /var/lib/php/session \
    && chown -R www-data:www-data /var/lib/php/

# Create config directory
RUN mkdir -p /etc/php4/conf.d/ \
    # Set location and timestamp \
    && echo 'date.timezone = "Asia/Tokyo"\ndate.default_latitude = 34.4549\ndate.default_longitude = 136.7258' > /etc/php4/conf.d/10_timezone.ini \
    # \
# Enable gd lib
# RUN echo "extension=gd.so" > /etc/php4/conf.d/30_gd.ini
#
# Build module mailparse
    && mkdir -p /tmp/install/ \
    && cd /tmp/install \
    && wget http://pecl.php.net/get/mailparse-2.1.6.tgz \
    && echo "0f84e1da1d074a4915a9bcfe2319ce84  mailparse-2.1.6.tgz" > md5sums \
    && md5sum -c md5sums \
    && tar xfz mailparse-2.1.6.tgz \
    && cd mailparse-2.1.6 \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/install \
    && echo "extension=mailparse.so" > /etc/php4/conf.d/20_mailparse.ini \
    && mkdir -p /usr/lib/php4/ \
    && ln -s /usr/local/lib/php/extensions/debug-zts-20020429/mailparse.so /usr/lib/php4/mailparse.so

# # Build module pecl_http \
# RUN mkdir -p /tmp/install/ \
#     && cd /tmp/install \
#     && wget http://pecl.php.net/get/pecl_http-1.7.6.tgz \
#     && echo "4926c17a24a11a9b1cf3ec613fad97cb  pecl_http-1.7.6.tgz" > md5sums \
#     && md5sum -c md5sums \
#     && tar xfz pecl_http-1.7.6.tgz \
#     && cd pecl_http-1.7.6 \
#     && phpize \
#     && ./configure \
#     && make \
#     && make install \
#     && rm -rf /tmp/install \
#     && echo "extension=http.so" > /etc/php4/conf.d/30_http.ini

# Build module xdebug
RUN mkdir -p /tmp/install/ \
    && cd /tmp/install \
    && wget http://pecl.php.net/get/xdebug-2.0.5.tgz \
    && echo "2d87dab7b6c499a80f0961af602d030c  xdebug-2.0.5.tgz" > md5sums \
    && md5sum -c md5sums \
    && tar xfz xdebug-2.0.5.tgz \
    && cd xdebug-2.0.5 \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/install \
    # \
    # Install sendmail replacement / set ip address of real mailserver to 172.17.42.1 \
    && mkdir -p /tmp/install/ \
    && cd /tmp/install \
    && wget https://github.com/simonswine/mini_sendmail/archive/1.3.8-1.tar.gz  \
    && tar xvfz 1.3.8-1.tar.gz \
    && cd mini_sendmail*/ \
    && make SMTP_HOST=172.17.0.3/16 \
    && cp -v mini_sendmail /usr/sbin/sendmail \
    && rm -rf /tmp/install

COPY php.ini /etc/
COPY docker-php-ext-* /usr/local/bin/
COPY apache/apache2.conf /etc/apache2/
COPY apache/000-default /etc/apache2/sites-available/default
COPY .bashrc /root/
# it'd be nice if we could not COPY apache2.conf until the end of the Dockerfile, but its contents are checked by PHP during compilation

# ##<autogenerated>##
# CMD ["php", "-a"]
# ##</autogenerated>##

COPY apache/apache2-foreground /usr/local/bin/
WORKDIR /var/www/html


EXPOSE 80
CMD ["apache2-foreground"]
