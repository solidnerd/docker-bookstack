#!/bin/bash
set -e

if [ ! -f '/var/www/BookStack/.env' ]; then
    cp /var/www/BookStack/.env.example /var/www/BookStack/.env

    if [ "$MYSQL_PORT_3306_TCP" ]; then
        sed -i "s/\(DB_HOST *= *\).*/\1mysql/" '/var/www/BookStack/.env'
        sed -i "s/\(DB_DATABASE *= *\).*/\1${MYSQL_ENV_MYSQL_DATABASE:-root}/" '/var/www/BookStack/.env'
        sed -i "s/\(DB_USERNAME *= *\).*/\1${MYSQL_ENV_MYSQL_USER:-$MYSQL_ENV_MYSQL_ROOT_PASSWORD}/" '/var/www/BookStack/.env'
        sed -i "s/\(DB_PASSWORD *= *\).*/\1${MYSQL_ENV_MYSQL_PASSWORD:-bookstack}/" '/var/www/BookStack/.env'

        cd /var/www/BookStack/ && php artisan key:generate && php artisan migrate --force
    else
        echo >&2 'warning: missing MYSQL_PORT_3306_TCP environment variables'
        echo >&2 '  Did you forget to --link some_mysql_container:mysql ?'
        exit 1
    fi
fi

apache2-foreground