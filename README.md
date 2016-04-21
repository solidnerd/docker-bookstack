# Docker Image For [BookStack](https://github.com/ssddanbrown/BookStack)
[![](https://badge.imagelayers.io/solidnerd/bookstack:latest.svg)](https://imagelayers.io/?images=solidnerd/bookstack:latest 'Get your own badge on imagelayers.io')

## Current Version: [0.9.2 ](https://github.com/SolidNerd/docker-bookstack/blob/preview/Dockerfile)

## Quickstart
With Docker Compose is a Quickstart very easy. Run the following command:

```
docker-compose up
```

and after that open your Browser and go to `http://localhost:8080` .


## How to use the Image without Docker compose
Networking changed in Docker v1.9, so you need to do one of the following steps.

### Docker < v1.9
1. MySQL Container:
```
docker run -d --name bookstack-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=bookstack -e MYSQL_USER=bookstack -e MYSQL_PASSWORD=secret mysql
```
2. BookStack Container:
```
docker run --name my-bookstack -d --link bookstack-mysql:mysql -p 8080:80 solidnerd/bookstack
```

### Docker 1.9+
1. Create a shared network:
   `docker network create bookstack_nw`

2.  MySQL container :
```
docker run -d --net bookstack_nw  \
-e MYSQL_ROOT_PASSWORD=secret \
-e MYSQL_DATABASE=bookstack \
-e MYSQL_USER=bookstack \
-e MYSQL_PASSWORD=secret \
 --name="bookstack_db" \
 mysql
```

3. Create BookStack Container
```
docker run -d --net bookstack_nw  \
-e DB_HOST=bookstack_db \
-e DB_DATABASE=bookstack \
-e DB_USERNAME=bookstack \
-e DB_PASSWORD=secret \
-p 8080:80
 solidnerd/bookstack
```

After the steps you can visit  `http://localhost:8080` .
