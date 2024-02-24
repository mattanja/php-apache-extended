FROM php:8.2.16-apache-bookworm
LABEL maintainer="Mattanja Kern <docker@kern.services>"

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
# Configure PHP
        libc-client-dev \
        libkrb5-dev \
        libxml2-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        zlib1g-dev \
        libzip-dev \
# Install required 3rd party tools
        graphicsmagick && \
# Configure extensions
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql soap gd zip opcache imap intl && \
    echo 'always_populate_raw_post_data = -1\nmax_execution_time = 240\nmax_input_vars = 1500\nupload_max_filesize = 32M\npost_max_size = 32M' > /usr/local/etc/php/conf.d/custom.ini && \
# Configure Apache as needed
    a2enmod rewrite && \
    apt-get clean && \
    apt-get -y purge \
        libc-client-dev \
        libkrb5-dev \
        libxml2-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        zlib1g-dev \
        libzip-dev && \
    rm -rf /var/lib/apt/lists/* /usr/src/*
