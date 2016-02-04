# Docker Image For [BookStack](https://github.com/ssddanbrown/BookStack)

* 0.7.2 ([Dockerfile](https://github.com/Kilhog/docker-bookstack/blob/master/Dockerfile))

## How to use this image

### Run MySQL Container
```
docker pull mysql
docker run -d --name bookstack-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=bookstack -e MYSQL_USER=bookstack -e MYSQL_PASSWORD=secret mysql
```
### Run Bookstack Container
```
docker pull kilhog/bookstack
docker run --name my-bookstack -d --link bookstack-mysql:mysql -p 8080:80 kilhog/bookstack
```
