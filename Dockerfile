FROM php:5.6-apache
RUN apt-get update && apt-get install -y git zlib1g-dev && docker-php-ext-install pdo pdo_mysql mbstring zip
RUN cd ~ && curl -sS https://getcomposer.org/installer | php
RUN mv ~/composer.phar /usr/local/bin/composer
RUN cd /var/www/ && git clone https://github.com/ssddanbrown/BookStack.git --branch release --single-branch BookStack
RUN cd /var/www/BookStack && composer install
COPY .env /var/www/BookStack/.env
RUN chown -R www-data:www-data /var/www/BookStack
