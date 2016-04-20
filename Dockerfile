FROM php:5.6-apache
MAINTAINER kilhog@protonmail.com

ENV BOOKSTACK BookStack
ENV BOOKSTACK_VERSION 0.9.2

RUN apt-get update && apt-get install -y git zlib1g-dev libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev wget \
   && docker-php-ext-install pdo pdo_mysql mbstring zip \
   && docker-php-ext-configure gd --with-freetype-dir=usr/include/ --with-jpeg-dir=/usr/include/ \
   && docker-php-ext-install gd \
   && cd /var/www && curl -sS https://getcomposer.org/installer | php \
   && mv /var/www/composer.phar /usr/local/bin/composer \
   && wget https://github.com/ssddanbrown/BookStack/archive/v${BOOKSTACK_VERSION}.tar.gz -O ${BOOKSTACK}.tar.gz \
   && tar -xf ${BOOKSTACK}.tar.gz && mv BookStack-${BOOKSTACK_VERSION} ${BOOKSTACK} && rm ${BOOKSTACK}.tar.gz  \
   && cd /var/www/BookStack && composer install \
   && chown -R www-data:www-data /var/www/BookStack \
   && apt-get -y autoremove \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY bookstack.conf /etc/apache2/sites-enabled/bookstack.conf
RUN a2enmod rewrite

COPY docker-entrypoint.sh /

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
