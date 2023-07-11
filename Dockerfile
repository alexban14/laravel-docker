FROM php:8.1 as php

RUN apt-get update
RUN apt-get install -y unzip libpq-dev libcurl4-gnutls-dev
RUN docker-php-ext-install pdo pdo_mysql bcmath

RUN pecl install -o -f redis \
	&& rm -rf /tmp/pear \
	&& docker-php-ext-enable redis

WORKDIR /var/www/html
COPY src/. .

COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer

COPY Docker/entrypoint.sh /entrypoint
RUN chmod +x /entrypoint

ENV PORT=8000
ENTRYPOINT ["/entrypoint"]

