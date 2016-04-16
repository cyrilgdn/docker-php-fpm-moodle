FROM php:7-fpm

# Install PHP modules:
# pgsql, zip, gd, mcrypt, mbstring, xmlrpc, opcache, soap, intl
RUN apt-get update && apt-get install -y \
        libpq-dev \
        libpq5 \
        zlib1g-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2-dev \
        libicu-dev

RUN pecl install intl

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install pgsql zip mbstring xmlrpc opcache soap intl

RUN docker-php-ext-install -j$(nproc) iconv mcrypt gd

# Config
ADD conf/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
ADD conf/php.ini /usr/local/etc/php/conf.d/php.ini

# Volume 
RUN mkdir /srv/data/
RUN chown www-data:www-data /srv/data
VOLUME /srv/data

# Install cron
RUN apt-get -y install cron

# TODO: supervisor
CMD service cron start && php-fpm
