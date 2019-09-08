FROM php:5.6-apache

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1
ENV APACHE_DOCUMENT_ROOT /var/www/html

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN apt-get update -qy && \
    apt-get install -qy --no-install-recommends \
                        git libmemcached-dev libmcrypt-dev zlib1g-dev libzip-dev zlib1g-dev \
                        libmagickwand-dev libcurl3-dev libz-dev libmemcached-dev && \
    apt-get install -qy nodejs

RUN pecl install imagick && \
    pecl install memcached-2.2.0

RUN docker-php-ext-install exif zip mysqli json curl soap dom pdo mcrypt gettext
RUN docker-php-ext-enable mcrypt memcached json exif zip curl dom mysqli pdo imagick soap

RUN curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_5.6.so `php-config --extension-dir` \
    && rm -Rf ioncube.tar.gz ioncube \
    && docker-php-ext-enable ioncube_loader_lin_5.6

WORKDIR /var/www/html
ADD . .
WORKDIR /var/www/html/deploy
RUN curl -s https://getcomposer.org/installer | php && \
    mv -v composer.phar composer/ && \
    php composer/composer.phar global require hirak/prestissimo && \
    php composer/composer.phar global require phing/phing && \
    php -d memory_limit=-1 composer/composer.phar install --no-dev

RUN a2enmod rewrite
