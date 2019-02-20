#!/bin/bash
set -e

echoerr() { echo "$@" 1>&2; }

# Split out host and port from DB_HOST env variable
IFS=":" read -r DB_HOST_NAME DB_PORT <<< "$DB_HOST"
DB_PORT=${DB_PORT:-3306}

if [ ! -f "$BOOKSTACK_HOME/.env" ]; then
  if [[ "${DB_HOST}" ]]; then
  cat > "$BOOKSTACK_HOME/.env" <<EOF
      # Application environment
      # Can be 'production', 'development', 'testing' or 'demo'
      APP_ENV=${APP_ENV:-production}
      
      # Enable debug mode
      # Shows advanced debug information and errors.
      # CAN EXPOSE OTHER VARIABLES, LEAVE DISABLED
      APP_DEBUG=${APP_DEBUG:-false}

      # Application key
      # Used for encryption where needed.
      # Run `php artisan key:generate` to generate a valid key.
      APP_KEY=${APP_KEY:-SomeRandomStringWith32Characters}

      # Application URL
      # This must be the root URL that you want to host BookStack on.
      # All URL's in BookStack will be generated using this value.
      APP_URL=${APP_URL:-null}

      # Application default language
      # The default language choice to show.
      # May be overridden by user-preference or visitor browser settings.
      APP_LANG=${APP_LANG:-en}

      # Auto-detect language for public visitors.
      # Uses browser-sent headers to infer a language.
      # APP_LANG will be used if such a header is not provided.
      APP_AUTO_LANG_PUBLIC=${APP_AUTO_LANG_PUBLIC:-true}

      # Database details
      # Host can contain a port (localhost:3306) or a separate DB_PORT option can be used.
      DB_HOST=${DB_HOST:-localhost}
      DB_PORT=${DB_PORT:-3306}
      DB_DATABASE=${DB_DATABASE:-bookstack}
      DB_USERNAME=${DB_USERNAME:-bookstack}
      DB_PASSWORD=${DB_PASSWORD:-password}

      # Mail system to use
      # Can be 'smtp', 'mail' or 'sendmail'
      MAIL_DRIVER=${MAIL_DRIVER:-smtp}
            
      # Mail sending options
      MAIL_FROM=${MAIL_FROM:-mail@bookstackapp.com}
      MAIL_FROM_NAME=${MAIL_FROM_NAME:-BookStack}

      # SMTP mail options
      MAIL_HOST=${MAIL_HOST:-localhost}
      MAIL_PORT=${MAIL_PORT:-1025}
      MAIL_USERNAME=${MAIL_USERNAME:-null}
      MAIL_PASSWORD=${MAIL_PASSWORD:-null}
      MAIL_ENCRYPTION=${MAIL_ENCRYPTION:-null}

      # Cache & Session driver to use
      # Can be 'file', 'database', 'memcached' or 'redis'
      CACHE_DRIVER=${CACHE_DRIVER:-file}
      SESSION_DRIVER=${SESSION_DRIVER:-file}

      # Session configuration
      SESSION_LIFETIME=${SESSION_LIFETIME:-120}
      SESSION_COOKIE_NAME=${SESSION_COOKIE_NAME:-bookstack_session}
      SESSION_SECURE_COOKIE=${SESSION_SECURE_COOKIE:-false}

      # Cache key prefix
      # Can be used to prevent conflicts multiple BookStack instances use the same store.
      CACHE_PREFIX=${CACHE_PREFIX:-bookstack}

      # Memcached server configuration
      # If using a UNIX socket path for the host, set the port to 0
      # This follows the following format: HOST:PORT:WEIGHT
      # For multiple servers separate with a comma
      MEMCACHED_SERVERS=${MEMCACHED_SERVERS:-127.0.0.1:11211:100}

      # Queue driver to use
      # Queue not really currently used but may be configurable in the future.
      # Would advise not to change this for now.
      QUEUE_DRIVER=sync

      # Storage system to use
      # Can be 'local', 'local_secure' or 's3'
      STORAGE_TYPE=${STORAGE_TYPE:-local}

      # Amazon S3 storage configuration
      STORAGE_S3_KEY=${STORAGE_S3_KEY:-false}
      STORAGE_S3_SECRET=${STORAGE_S3_SECRET:-false}
      STORAGE_S3_REGION=${STORAGE_S3_REGION:-false}
      STORAGE_S3_BUCKET=${STORAGE_S3_BUCKET:-false}

      # S3 endpoint to use for storage calls
      # Only set this if using a non-Amazon s3-compatible service such as Minio
      STORAGE_S3_ENDPOINT=${STORAGE_S3_ENDPOINT:-false}

      # Storage URL prefix
      # Used as a base for any generated image urls.
      # An s3-format URL will be generated if not set.
      STORAGE_URL=${STORAGE_URL:-false}

      # Authentication method to use
      # Can be 'standard' or 'ldap'
      AUTH_METHOD=${AUTH_METHOD:-standard}

      # Social authentication configuration
      # All disabled by default.
      # Refer to https://www.bookstackapp.com/docs/admin/third-party-auth/

      AZURE_APP_ID=${AZURE_APP_ID:-false}
      AZURE_APP_SECRET=${AZURE_APP_SECRET:-false}
      AZURE_TENANT=${AZURE_TENANT:-false}
      AZURE_AUTO_REGISTER=${AZURE_AUTO_REGISTER:-false}
      AZURE_AUTO_CONFIRM_EMAIL=${AZURE_AUTO_CONFIRM_EMAIL:-false}

      DISCORD_APP_ID=${DISCORD_APP_ID:-false}
      DISCORD_APP_SECRET=${DISCORD_APP_SECRET:-false}
      DISCORD_AUTO_REGISTER=${DISCORD_AUTO_REGISTER:-false}
      DISCORD_AUTO_CONFIRM_EMAIL=${DISCORD_AUTO_CONFIRM_EMAIL:-false}

      FACEBOOK_APP_ID=${FACEBOOK_APP_ID:-false}
      FACEBOOK_APP_SECRET=${FACEBOOK_APP_SECRET:-false}
      FACEBOOK_AUTO_REGISTER=${FACEBOOK_AUTO_REGISTER:-false}
      FACEBOOK_AUTO_CONFIRM_EMAIL=${FACEBOOK_AUTO_CONFIRM_EMAIL:-false}

      GITHUB_APP_ID=${GITHUB_APP_ID:-false}
      GITHUB_APP_SECRET=${GITHUB_APP_SECRET:-false}
      GITHUB_AUTO_REGISTER=${GITHUB_AUTO_REGISTER:-false}
      GITHUB_AUTO_CONFIRM_EMAIL=${GITHUB_AUTO_CONFIRM_EMAIL:-false}

      GITLAB_APP_ID=${GITLAB_APP_ID:-false}
      GITLAB_APP_SECRET=${GITLAB_APP_SECRET:-false}
      GITLAB_BASE_URI=${GITLAB_BASE_URI:-false}
      GITLAB_AUTO_REGISTER=${GITLAB_AUTO_REGISTER:-false}
      GITLAB_AUTO_CONFIRM_EMAIL=${GITLAB_AUTO_CONFIRM_EMAIL:-false}

      GOOGLE_APP_ID=${GOOGLE_APP_ID:-false}
      GOOGLE_APP_SECRET=${GOOGLE_APP_SECRET:-false}
      GOOGLE_SELECT_ACCOUNT=${GOOGLE_SELECT_ACCOUNT:-false}
      GOOGLE_AUTO_REGISTER=${GOOGLE_AUTO_REGISTER:-false}
      GOOGLE_AUTO_CONFIRM_EMAIL=${GOOGLE_AUTO_CONFIRM_EMAIL:-false}

      OKTA_BASE_URL=${OKTA_BASE_URL:-false}
      OKTA_APP_ID=${OKTA_APP_ID:-false}
      OKTA_APP_SECRET=${OKTA_APP_SECRET:-false}
      OKTA_AUTO_REGISTER=${OKTA_AUTO_REGISTER:-false}
      OKTA_AUTO_CONFIRM_EMAIL=${OKTA_AUTO_CONFIRM_EMAIL:-false}

      SLACK_APP_ID=${SLACK_APP_ID:-false}
      SLACK_APP_SECRET=${SLACK_APP_SECRET:-false}
      SLACK_AUTO_REGISTER=${SLACK_AUTO_REGISTER:-false}
      SLACK_AUTO_CONFIRM_EMAIL=${SLACK_AUTO_CONFIRM_EMAIL:-false}

      TWITCH_APP_ID=${TWITCH_APP_ID:-false}
      TWITCH_APP_SECRET=${TWITCH_APP_SECRET:-false}
      TWITCH_AUTO_REGISTER=${TWITCH_AUTO_REGISTER:-false}
      TWITCH_AUTO_CONFIRM_EMAIL=${TWITCH_AUTO_CONFIRM_EMAIL:-false}

      TWITTER_APP_ID=${TWITTER_APP_ID:-false}
      TWITTER_APP_SECRET=${TWITTER_APP_SECRET:-false}
      TWITTER_AUTO_REGISTER=${TWITTER_AUTO_REGISTER:-false}
      TWITTER_AUTO_CONFIRM_EMAIL=${TWITTER_AUTO_CONFIRM_EMAIL:-false}

      # LDAP authentication configuration
      # Refer to https://www.bookstackapp.com/docs/admin/ldap-auth/
      LDAP_SERVER=${LDAP_SERVER:-false}
      LDAP_BASE_DN=${LDAP_BASE_DN:-false}
      LDAP_DN=${LDAP_DN:-false}
      LDAP_PASS=${LDAP_PASS:-false}
      LDAP_USER_FILTER=${LDAP_USER_FILTER:-false}
      LDAP_VERSION=${LDAP_VERSION:-false}
      LDAP_TLS_INSECURE=${LDAP_TLS_INSECURE:-false}
      LDAP_EMAIL_ATTRIBUTE=${LDAP_EMAIL_ATTRIBUTE:-mail}
      LDAP_FOLLOW_REFERRALS=${LDAP_FOLLOW_REFERRALS:-true}

      # LDAP group sync configuration
      # Refer to https://www.bookstackapp.com/docs/admin/ldap-auth/
      LDAP_USER_TO_GROUPS=${LDAP_USER_TO_GROUPS:-false}
      LDAP_GROUP_ATTRIBUTE=${LDAP_GROUP_ATTRIBUTE:-"memberOf"}
      LDAP_REMOVE_FROM_GROUPS=${LDAP_REMOVE_FROM_GROUPS:-false}

      # Disable default third-party services such as Gravatar and Draw.IO
      # Service-specific options will override this option
      DISABLE_EXTERNAL_SERVICES=${DISABLE_EXTERNAL_SERVICES:-false}

      # Possible placeholders: ${hash} ${size} ${email}
      # If set, Avatars will be fetched regardless of DISABLE_EXTERNAL_SERVICES option.
      # Example: AVATAR_URL=https://seccdn.libravatar.org/avatar/${hash}?s=${size}&d=identicon
      AVATAR_URL=${AVATAR_URL:-null}

      # Enable Draw.io integration
      DRAWIO=${DRAWIO:-true}

      # Default item listing view
      # Used for public visitors and user's without a preference
      # Can be 'list' or 'grid'
      APP_VIEWS_BOOKS=${APP_VIEWS_BOOKS:-list}
      APP_VIEWS_BOOKSHELVES=${APP_VIEWS_BOOKSHELVES:-grid}

      # Page revision limit
      # Number of page revisions to keep in the system before deleting old revisions.
      # If set to 'false' a limit will not be enforced.
      REVISION_LIMIT=${REVISION_LIMIT:-50}

      # Allow <script> tags in page content
      # Note, if set to 'true' the page editor may still escape scripts.
      ALLOW_CONTENT_SCRIPTS=${ALLOW_CONTENT_SCRIPTS:-false}

      # Indicate if robots/crawlers should crawl your instance.
      # Can be 'true', 'false' or 'null'.
      # The behaviour of the default 'null' option will depend on the 'app-public' admin setting.
      # Contents of the robots.txt file can be overridden, making this option obsolete.
      ALLOW_ROBOTS=${ALLOW_ROBOTS:-null}
EOF
sed -ie "s/single/errorlog/g" config/app.php
    else
        echo >&2 'error: missing DB_HOST environment variable'
        exit 1
    fi
fi

echoerr wait-for-db: waiting for ${DB_HOST_NAME}:${DB_PORT}

timeout 15 bash <<EOT
while ! (echo > /dev/tcp/${DB_HOST_NAME}/${DB_PORT}) >/dev/null 2>&1;
    do sleep 1;
done;
EOT
RESULT=$?

if [ $RESULT -eq 0 ]; then
  # sleep another second for so that we don't get a "the database system is starting up" error
  sleep 1
  echoerr wait-for-db: done
else
  echoerr wait-for-db: timeout out after 15 seconds waiting for ${DB_HOST_NAME}:${DB_PORT}
fi

composer install

php artisan key:generate

php artisan migrate --force


echo "Setting folder permissions for uploads"
chown -R www-data:www-data public/uploads && chmod -R 775 public/uploads
chown -R www-data:www-data storage/uploads && chmod -R 775 storage/uploads

php artisan cache:clear

php artisan view:clear

exec apache2-foreground
