## Docker Image For [BookStack](https://github.com/ssddanbrown/BookStack)

[![Build Status](https://travis-ci.org/solidnerd/docker-bookstack.svg?branch=master)](https://travis-ci.org/solidnerd/docker-bookstack) [![](https://images.microbadger.com/badges/image/solidnerd/bookstack.svg)](https://microbadger.com/images/solidnerd/bookstack "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/commit/solidnerd/bookstack.svg)](https://microbadger.com/images/solidnerd/bookstack "Get your own commit badge on microbadger.com") [![](https://images.microbadger.com/badges/version/solidnerd/bookstack.svg)](https://microbadger.com/images/solidnerd/bookstack "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/license/solidnerd/bookstack.svg)](https://microbadger.com/images/solidnerd/bookstack "Get your own license badge on microbadger.com")

## Current Version: [0.24.2](https://github.com/SolidNerd/docker-bookstack/blob/master/Dockerfile)

### Changes
In 0.12.2 we removed `DB_PORT` . You can now specify the port via `DB_HOST` like `DB_HOST=mysql:3306`

### Quickstart
With Docker Compose is a Quickstart very easy. Run the following command:

```
docker-compose up
```

and after that open your Browser and go to [http://localhost:8080](http://localhost:8080) .

### Issues

If you have any issues feel free to create an [issue on GitHub](https://github.com/solidnerd/docker-bookstack/issues).


### How to use the Image without Docker compose
Networking changed in Docker v1.9, so you need to do one of the following steps.

#### Docker < v1.9
1. MySQL Container:
```bash
docker run -d --name bookstack-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=bookstack -e MYSQL_USER=bookstack -e MYSQL_PASSWORD=secret mysql:5.7.21
```
2. BookStack Container:
```bash
docker run --name my-bookstack -d --link bookstack-mysql:mysql -p 8080:80 solidnerd/bookstack:0.24.2
```

#### Docker 1.9+

1.Create a shared network:

```bash
docker network create bookstack_nw
```

2.MySQL container :
```bash
docker run -d --net bookstack_nw  \
-e MYSQL_ROOT_PASSWORD=secret \
-e MYSQL_DATABASE=bookstack \
-e MYSQL_USER=bookstack \
-e MYSQL_PASSWORD=secret \
 --name="bookstack_db" \
 mysql:5.7.21
```


3.Create BookStack Container

```bash
docker run -d --net bookstack_nw  \
-e DB_HOST=bookstack_db:3306 \
-e DB_DATABASE=bookstack \
-e DB_USERNAME=bookstack \
-e DB_PASSWORD=secret \
-p 8080:80 \
 solidnerd/bookstack:0.24.2
```

After the steps you can visit [http://localhost:8080](http://localhost:8080) . You can login with username 'admin@admin.com' and password 'password'.


### Inspiration

This is a fork of [Kilhog/docker-bookstack](https://github.com/Kilhog/docker-bookstack). Kilhog did the intial work, but I want to go in a different direction.
