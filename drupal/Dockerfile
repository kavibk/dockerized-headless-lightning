# Recommended PHP Version for Headless Lightning Drupal Distribution
FROM php:7.0-fpm-alpine

# Add maintainer label
LABEL maintainer="kaden@vermilion.tech"

# Install the required PHP extensions
RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        libpng-dev \
        git \
        patch \
        mysql-client \
    && docker-php-ext-install -j "$(nproc)" \
        gd \
        opcache \
        pdo_mysql \
    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --virtual .drupal-phpexts-rundeps $runDeps

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Install Composer as per `https://getcomposer.org/download/#main`
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --filename=composer --install-dir=/bin && \
    php -r "unlink('composer-setup.php');"

# Changing working directory to /usr/src/headless-lightning
WORKDIR /usr/src/headless-lightning

# Clone headless-lightning repository into directory
RUN git clone https://github.com/acquia/headless-lightning.git .

# Install Headless Lightning dependencies
RUN composer install

# Install Drush
RUN composer require drush/drush

# Add /opt/headless-lightning/vendor/bin to PATH
ENV PATH="/opt/headless-lightning/vendor/bin:${PATH}"

# Delete build dependencies
# RUN apk del .build-deps

# Add settings.php
COPY settings.php /tmp/settings.php

# Change owner of /opt/build
RUN chown -R www-data:www-data /usr/src/headless-lightning

# Add Docker entrypoint
COPY docker-entrypoint.sh /usr/local/bin/

# Make symbolic link
RUN ln -s usr/local/bin/docker-entrypoint.sh /

# Change working directory to /opt/headless-lightning
WORKDIR /opt/headless-lightning

# Expose volume
VOLUME /opt/headless-lightning

# Set Docker entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]
