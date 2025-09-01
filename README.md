# Docker Image For [BookStack](https://github.com/ssddanbrown/BookStack)

![Build Status](https://img.shields.io/github/actions/workflow/status/solidnerd/docker-bookstack/master.yml)
![Latest release](https://img.shields.io/github/v/tag/solidnerd/docker-bookstack?label=Latest%20release)
![GitHub contributors](https://img.shields.io/github/contributors/solidnerd/docker-bookstack)

## Changes

Users of version 24.2.3 should switch to 24.2.3-1 (or higher); a maintainer
erroneously set image tag 24.2.3 to use 23.2.3 as the release.

Versions higher than 23.6.2 no longer use an in-container `.env` file for
environment variable management. Instead, the preferred approach is to manage
them directly with the container runtime (e.g. Docker's `-e`). This is to
simplify troubleshooting if and when errors occur. The most important change is
that `${APP_KEY}` is no longer provided for you, instead it is up to the
operator to ensure this value is present. Versions prior to this supplied
`${APP_KEY}` (with a default of `SomeRandomStringWith32Characters`. A full
reference of available environment variables is available in the [Bookstack
repository](https://github.com/BookStackApp/BookStack/blob/development/.env.example.complete)

The version 23.6.0 is broken due to a bad `.env` configuration created by the
entrypoint script. This is fixed in version 23.6.0-1.

In 0.28.0 we changed the container http port from 80 to 8080 to allow root
privileges to be dropped

In 0.12.2 we removed `DB_PORT` . You can now specify the port via `DB_HOST` like
`DB_HOST=mysql:3306`

## Quickstart

With Docker Compose is a Quickstart very easy. Run the following command:

```bash
docker compose up
```

and after that open your Browser and go to
[http://localhost:8080](http://localhost:8080) . You can login with username
`admin@admin.com` and password `password`.

## Issues

If you have any issues feel free to create an [issue on GitHub](https://github.com/solidnerd/docker-bookstack/issues).

## How to use the Image without Docker compose

Note that if you want to use LDAP, `$` has to be escape like `\$`, i.e. `-e "LDAP_USER_FILTER"="(&(uid=\${user}))"`

### Docker 1.9+

1. Create a shared network:

   ```bash
   docker network create bookstack_nw
   ```

2. Run MySQL container :

   ```bash
   docker run -d --net bookstack_nw  \
   -e MYSQL_ROOT_PASSWORD=secret \
   -e MYSQL_DATABASE=bookstack \
   -e MYSQL_USER=bookstack \
   -e MYSQL_PASSWORD=secret \
    --name="bookstack_db" \
    mysql:9.2.0
   ```

3. Run BookStack Container

   ```bash
   docker run -d --net bookstack_nw \
   -e DB_HOST=bookstack_db:3306 \
   -e DB_DATABASE=bookstack \
   -e DB_USERNAME=bookstack \
   -e DB_PASSWORD=secret \
   -e APP_URL=http://localhost:8080 \
   -e APP_KEY=SomeRandomStringWith32Characters \
   -p 8080:8080 \
   --name="bookstack_25.7.2" \
    solidnerd/bookstack:25.7.2
   ```

    The APP_URL parameter should be the base URL for your BookStack instance without
    a trailing slash, but including any port numbers. For example:

    `APP_URL=http://example.com` or `APP_URL=http://localhost:8080`.

    The following environment variables are required for Bookstack to start:
    - `APP_KEY`
    - `APP_URL`
    - `DB_HOST` (in the form `${hostname_or_ip_address}:${port}`)
    - `DB_DATABASE`
    - `DB_USERNAME`
    - `DB_PASSWORD`

### Volumes

To access your important bookstack folders on your host system change `<HOST>`
in the following line to your host directory and add it then to your run
command:

```bash
-v <HOST>:/var/www/bookstack/public/uploads \
-v <HOST>:/var/www/bookstack/storage/uploads
```

After these steps you can visit [http://localhost:8080](http://localhost:8080).
You can login with username `admin@admin.com` and password `password`.

## Inspiration

This is a fork of
[Kilhog/docker-bookstack](https://github.com/Kilhog/docker-bookstack). Kilhog
did the intial work, but I want to go in a different direction.
