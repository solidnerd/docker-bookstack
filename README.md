[![](https://images.microbadger.com/badges/image/solidnerd/bookstack.svg)](http://microbadger.com/images/solidnerd/bookstack "Get your own image badge on microbadger.com")

# Docker Image For [BookStack](https://github.com/ssddanbrown/BookStack)

## Current Version: [0.12.1](https://github.com/SolidNerd/docker-bookstack/blob/master/Dockerfile)

## Quickstart
With Docker Compose is a Quickstart very easy. Run the following command:

```
docker-compose up
```

and after that open your Browser and go to [http://localhost:8080](http://localhost:8080) .


## How to use the Image without Docker compose
Networking changed in Docker v1.9, so you need to do one of the following steps.

### Docker < v1.9
1. MySQL Container:
```
docker run -d --name bookstack-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=bookstack -e MYSQL_USER=bookstack -e MYSQL_PASSWORD=secret mysql
```
2. BookStack Container:
```
docker run --name my-bookstack -d --link bookstack-mysql:mysql -p 8080:80 solidnerd/bookstack:0.12.1
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

After the steps you can visit [http://localhost:8080](http://localhost:8080) .


## Inspiration

It comes from [Kilhog/docker-bookstack](https://github.com/Kilhog/docker-bookstack). He did the initially work it was a fork previously but know i want to go in a other direction.
