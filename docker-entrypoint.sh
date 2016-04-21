#!/bin/bash
set -e

echoerr() { echo "$@" 1>&2; }

if [ ! -f '/var/www/BookStack/.env' ]; then
  if [ "$DB_HOST" ]; then
  cat > /var/www/BookStack/.env <<EOF
      # Environment
      APP_ENV=production
      APP_DEBUG=false
      APP_KEY=SomeRandomString

      # Database details
      DB_HOST=${DB_HOST:-localhost}
      DB_DATABASE=${DB_DATABASE:-bookstack}
      DB_USERNAME=${DB_USERNAME:-bookstack}
      DB_PASSWORD=${DB_PASSWORD:-password}

      # Cache and session
      CACHE_DRIVER=file
      SESSION_DRIVER=file
      # If using Memcached, comment the above and uncomment these
      #CACHE_DRIVER=memcached
      #SESSION_DRIVER=memcached
      QUEUE_DRIVER=sync

      # Memcached settings
      # If using a UNIX socket path for the host, set the port to 0
      # This follows the following format: HOST:PORT:WEIGHT
      # For multiple servers separate with a comma
      MEMCACHED_SERVERS=127.0.0.1:11211:100

      # Storage
      STORAGE_TYPE=local
      # Amazon S3 Config
      STORAGE_S3_KEY=false
      STORAGE_S3_SECRET=false
      STORAGE_S3_REGION=false
      STORAGE_S3_BUCKET=false
      # Storage URL
      # Used to prefix image urls for when using custom domains/cdns
      STORAGE_URL=false

      # General auth
      AUTH_METHOD=standard

      # Social Authentication information. Defaults as off.
      GITHUB_APP_ID=false
      GITHUB_APP_SECRET=false
      GOOGLE_APP_ID=false
      GOOGLE_APP_SECRET=false
      # URL used for social login redirects, NO TRAILING SLASH
EOF
    else
        echo >&2 'warning: missing MYSQL_PORT_3306_TCP environment variables'
        echo >&2 '  Did you forget to --link some_mysql_container:mysql ?'
        exit 1
    fi
fi

echoerr wait-for-db: waiting for ${DB_HOST}:3306

timeout 15 bash <<EOT
while ! (echo > /dev/tcp/${DB_HOST}/3306) >/dev/null 2>&1;
    do sleep 1;
done;
EOT
RESULT=$?

if [ $RESULT -eq 0 ]; then
  # sleep another second for so that we don't get a "the database system is starting up" error
  sleep 1
  echoerr wait-for-db: done
else
  echoerr wait-for-db: timeout out after 15 seconds waiting for ${DB_HOST}:3306
fi

cd /var/www/BookStack/ && php artisan key:generate && php artisan migrate --force

exec apache2-foreground
