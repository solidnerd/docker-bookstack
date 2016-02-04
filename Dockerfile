FROM php:5.6-apache
MAINTAINER kilhog@protonmail.com
RUN apt-get update && apt-get install -y git zlib1g-dev libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev \
   && docker-php-ext-install pdo pdo_mysql mbstring zip \
   && docker-php-ext-configure gd --with-freetype-dir=usr/include/ --with-jpeg-dir=/usr/include/ \
   && docker-php-ext-install gd
RUN cd ~ && curl -sS https://getcomposer.org/installer | php
RUN mv ~/composer.phar /usr/local/bin/composer
RUN cd /var/www/ && git clone https://github.com/ssddanbrown/BookStack.git --branch 0.7.2 --single-branch BookStack
RUN cd /var/www/BookStack && composer install
RUN chown -R www-data:www-data /var/www/BookStack
COPY bookstack.conf /etc/apache2/sites-enabled/bookstack.conf
RUN a2enmod rewrite

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]