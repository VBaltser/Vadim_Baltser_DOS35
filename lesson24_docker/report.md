# Dockerfile / Docker compose

## Создание структуры

Создал структуру файлов:

```bash
vadim@TMS-UBUNTU-VM1:~/lesson24_docker$ tree
.
├── app
│   └── static
│       └── index.html
├── Dockerfile
└── nginx.conf

3 directories, 3 files
```

Файл `index.html`:

```html
<!DOCTYPE html>
<html>
<head><title>Test</title></head>
<body><h1>Hello from Docker!</h1></body>
</html>
```

Файл `nginx.conf`:

```
events {
    worker_connections 1024;
}

http {
    server {
        listen 8080;
        server_name localhost;

        location / {
            root /app/static;
            index index.html;
        }
    }
}
```

## Dockerfile

```dockerfile
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y nginx curl && \
    mkdir -p /app/static && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY app/static/ /app/static/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
```

- `FROM ubuntu:20.04` - базовый образ Ubuntu 20.04
- `ENV DEBIAN_FRONTEND=noninteractive` - эта переменная говорит пакетному менеджеру apt/debconf: не задавать интерактивные вопросы при установке пакетов
- `RUN apt-get update && apt-get install -y nginx curl` - установка nginx и curl
- `mkdir -p /app/static` - создание каталога `/app/static`
- `rm -rf /var/lib/apt/lists/*` - удаление кэша пакетного менеджера apt после установки пакетов. В Dockerfile каждая инструкция RUN создаёт новый слой. Без удаления эти файлы остаются в слое Docker-образа
- `COPY nginx.conf /etc/nginx/nginx.conf` - копирование в контейнер nginx.conf
- `COPY app/static/ /app/static/` - копирование в контейнер статичных файлов
- `EXPOSE 8080` - объявление порта 8080
- `CMD ["nginx", "-g", "daemon off;"]` - запуск nginx в foreground-режиме

## Сборка и запуск

Сборка образа:

```bash
vadim@TMS-UBUNTU-VM1:~/lesson24_docker$ sudo docker build -t lesson24-server .

vadim@TMS-UBUNTU-VM1:~/lesson24_docker$ sudo docker image ls
IMAGE                    ID             DISK USAGE   CONTENT SIZE   EXTRA
lesson24-server:latest   76469ce2ddd5        217MB         56.4MB        
```

Запсук контейнера:

```bash
vadim@TMS-UBUNTU-VM1:~/lesson24_docker$ sudo docker run -d -p 8080:8080 --name lesson24-server-container lesson24-server
93e9f62c0be25c4d2ab7c1b45124bda40714da7b61e4bdb74a90d45a4bc10974

vadim@TMS-UBUNTU-VM1:~/lesson24_docker$ sudo docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS          PORTS                                         NAMES
93e9f62c0be2   lesson24-server   "nginx -g 'daemon of…"   11 seconds ago   Up 10 seconds   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp   lesson24-server-container
```

Проверка работы веб сервера в контейнере:

```bash
vadim@TMS-UBUNTU-VM1:~/lesson24_docker$ curl localhost:8080
<!DOCTYPE html>
<html>
<head><title>Test</title></head>
<body><h1>Hello from Docker!</h1></body>
```

## Docker-compose

Создал структуру файлов:

```bash
vadim@TMS-UBUNTU-VM1:~/lesson24_docker_compose$ tree .
.
├── docker-compose.yml
└── nginx
    └── nginx.conf
```

Создал простой `nginx.conf`:

```
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html;
        }
    }
}
```

Содержимое `docker-compose.yml`:

```yml
version: '3'

services:
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: mydb

  web:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    links:
      - db
```

С помощью этого конфига запустится 2 сервиса: `db` (postgres) и `web` (nginx). В `db` передаются переменные

```
POSTGRES_USER: myuser
POSTGRES_PASSWORD: mypassword
POSTGRES_DB: mydb
```

К `web` в контейнер монтируется файл `nginx.conf` с хоста в режиме read-only. Также устанавливается связь с сервисом `db` через `links`. По факту создается запись в `/etc/hosts` типа `172.18.0.2  db`

## Запуск docker-compose

Запустил контейнеры:

```bash
sudo docker compose up
```

```bash
vadim@TMS-UBUNTU-VM1:~/lesson24_docker_compose$ sudo docker compose ps
WARN[0000] /home/vadim/lesson24_docker_compose/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
NAME                            IMAGE             COMMAND                  SERVICE   CREATED          STATUS          PORTS
lesson24_docker_compose-db-1    postgres:latest   "docker-entrypoint.s…"   db        52 seconds ago   Up 50 seconds   5432/tcp
lesson24_docker_compose-web-1   nginx:latest      "/docker-entrypoint.…"   web       51 seconds ago   Up 49 seconds   0.0.0.0:80->80/tcp, [::]:80->80/tcp
```

Контейнеры запущены.

```bash
vadim@TMS-UBUNTU-VM1:~/lesson24_docker_compose$ curl http://localhost:80
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, nginx is successfully installed and working.
Further configuration is required for the web server, reverse proxy, 
API gateway, load balancer, content cache, or other features.</p>

<p>For online documentation and support please refer to
<a href="https://nginx.org/">nginx.org</a>.<br/>
To engage with the community please visit
<a href="https://community.nginx.org/">community.nginx.org</a>.<br/>
For enterprise grade support, professional services, additional 
security features and capabilities please refer to
<a href="https://f5.com/nginx">f5.com/nginx</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

Сервис nginx запустился