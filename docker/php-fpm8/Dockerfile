FROM php:8.1-fpm-bullseye

ARG GID
ARG UID
ENV UID $UID
ENV GID $GID

RUN docker-php-ext-install mysqli pdo pdo_mysql bcmath

COPY jsmin-3.0.0.tar.gz /tmp/jsmin-3.0.0.tar.gz

RUN apt-get update && apt-get install -y wget \
    git \
    zip \
    unzip \
    default-mysql-client \
    && pecl install /tmp/jsmin-3.0.0.tar.gz \
    && pecl install xdebug-3.1.4

# Install PECT upload progress.
RUN mkdir -p /usr/src/php/ext/uploadprogress; \
    up_url="https://pecl.php.net/get/uploadprogress-2.0.2.tgz"; \
    wget -qO- "${up_url}" | tar xz --strip-components=1 -C /usr/src/php/ext/uploadprogress; \
    docker-php-ext-install uploadprogress;

# Install PNG, JPEG php extensions.
RUN apt-get install -y zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev libwebp-dev \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ --with-webp \
    && docker-php-ext-install gd  \
    && rm -rf /var/cache/apt

# Composer
RUN curl -sS https://getcomposer.org/download/latest-stable/composer.phar  -L -o composer.phar \
  && mv composer.phar /usr/local/bin/composer \
  && chmod +x /usr/local/bin/composer
ENV PATH "$PATH:/root/.composer/vendor/bin"

COPY xdebug3.ini $PHP_INI_DIR/conf.d/
COPY php.ini $PHP_INI_DIR/conf.d/
COPY jsmin.ini $PHP_INI_DIR/conf.d/

RUN echo "Creating user & group" \
  && groupadd -g "$GID" drupal \
  && useradd -r -u "$UID" -g drupal -m drupal

RUN echo "export PATH=$PATH:/drupal/vendor/bin" >> /home/drupal/.bashrc

WORKDIR /drupal
