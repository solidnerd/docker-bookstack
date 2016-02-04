# BookStack Docker image

## Usage with linked server

First you need to run MySQL server in Docker, and this image need link a running mysql instance container :
```
docker run --name my-bookstack -d --link bookstack-mysql:mysql -p 8080:80 ??/bookstack
```

