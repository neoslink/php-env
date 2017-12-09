FROM php:7.1.11-fpm

RUN apt-get update && apt-get install -y \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  libpcre3-dev \
  curl

RUN docker-php-ext-install -j$(nproc) mysqli                                                    && \
  docker-php-ext-install -j$(nproc) pdo_mysql                                                   && \
  docker-php-ext-install -j$(nproc) iconv mcrypt                                                && \
  docker-php-ext-configure opcache --enable-opcache                                             && \
  docker-php-ext-install -j$(nproc) opcache                                                     && \
  docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/   && \
  docker-php-ext-install -j$(nproc) gd

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the Drush version.
ENV DRUSH_VERSION 8.1.15

RUN curl -fsSL -o /usr/local/bin/drush "https://github.com/drush-ops/drush/releases/download/$DRUSH_VERSION/drush.phar" && \
  chmod +x /usr/local/bin/drush

RUN curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer && \
  chmod +x /usr/local/bin/composer && \
  composer self-update
