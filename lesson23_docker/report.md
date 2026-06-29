# Docker volumes

Для этого урока буду использовать образ `alpine:3.20`

## Скачивание образа и запуск

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker pull alpine:3.20
vadim@TMS-UBUNTU-VM1:~$ sudo docker run -d \
  --name demo-web \
  -p 8080:8080 \
  -e APP_NAME="lesson23" \
  -e APP_ENV="dev" \
  alpine:3.20 \
  sh -c "apk add --no-cache busybox-extras >/dev/null && while true; do echo -e \"HTTP/1.1 200 OK\r\n\r\nHello from \$APP_NAME\" | nc -l -p 8080; done"
vadim@TMS-UBUNTU-VM1:~$ sudo docker images 
IMAGE         ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:3.20   d9e853e87e55       12.2MB         3.71MB    U   
```

- `-d` запуск в фоне
- `--name` конкретное имя контейнера вместо случайного
- `-p` бинд портов
- `-e` переменные окружения
- `sh -c` выполнение команды внутри контейнера

Команды, выполняемые в контейнере:

- `apk add --no-cache busybox-extras` - установка минимального пакета, чтобы создать примитивный "веб-сервер", который будет просто отвечать на `curl`.

- `while true; do echo -e \"HTTP/1.1 200 OK\r\n\r\nHello from \$APP_NAME\" | nc -l -p 8080; done` - создание слушателя порта 8080, который будет отвечать `Hello from lesson23`

Контейнер запущен:

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker ps 
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                         NAMES
43c55ff38c53   alpine:3.20   "sh -c 'apk add --no…"   42 seconds ago   Up 41 seconds   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp   demo-web
```

Проверка:

```bash
vadim@TMS-UBUNTU-VM1:~$ curl http://localhost:8080
Hello from lesson23
```

## Создание volume

Сейчас нет ни одного volume

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker volume ls
DRIVER    VOLUME NAME
```

Создаю новый:

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker volume create lesson23-data
lesson23-data
vadim@TMS-UBUNTU-VM1:~$ sudo docker volume ls
DRIVER    VOLUME NAME
local     lesson23-data
vadim@TMS-UBUNTU-VM1:~$ sudo docker volume inspect lesson23-data
[
    {
        "CreatedAt": "2026-06-29T04:39:25Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/lesson23-data/_data",
        "Name": "lesson23-data",
        "Options": null,
        "Scope": "local"
    }
]
```

Сейчас у контейнера нет маунтов:

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker inspect demo-web --format '{{json .Mounts}}'
[]
```

Остановка и удаление контейнера:

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker stop demo-web
demo-web
vadim@TMS-UBUNTU-VM1:~$ sudo docker rm demo-web
demo-web
```

Запустил контейнера с параметром `-v lesson23-data:/data \`

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker run -d \
  --name demo-web \
  -p 8080:8080 \
  -e APP_NAME="lesson23" \
  -e APP_ENV="dev" \
  -v lesson23-data:/data \ 
  alpine:3.20 \
  sh -c "apk add --no-cache busybox-extras >/dev/null && while true; do echo -e \"HTTP/1.1 200 OK\r\n\r\nHello from \$APP_NAME\" | nc -l -p 8080; done"
```

Теперь volume подключен к контейнеру

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker inspect demo-web --format '{{json .Mounts}}'
[{"Type":"volume","Name":"lesson23-data","Source":"/var/lib/docker/volumes/lesson23-data/_data","Destination":"/data","Driver":"local","Mode":"z","RW":true,"Propagation":""}]
```

## Создание сети

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
263a43d22825   bridge    bridge    local
be6b134a6ac2   host      host      local
d9b877a5b3ff   none      null      local

vadim@TMS-UBUNTU-VM1:~$ sudo docker network create lesson23-net
4b35900d5d514bcd07f88bab8e539cc6ff2461b8e578e185a363ad3880d58190

vadim@TMS-UBUNTU-VM1:~$ sudo docker network ls
NETWORK ID     NAME           DRIVER    SCOPE
263a43d22825   bridge         bridge    local
be6b134a6ac2   host           host      local
4b35900d5d51   lesson23-net   bridge    local
d9b877a5b3ff   none           null      local

vadim@TMS-UBUNTU-VM1:~$ sudo docker network inspect lesson23-net
[
    {
        "Name": "lesson23-net",
        "Id": "4b35900d5d514bcd07f88bab8e539cc6ff2461b8e578e185a363ad3880d58190",
        "Created": "2026-06-29T04:49:24.692283588Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv4": true,
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Options": {},
        "Labels": {},
        "Containers": {},
        "Status": {
            "IPAM": {
                "Subnets": {
                    "172.18.0.0/16": {
                        "IPsInUse": 3,
                        "DynamicIPsAvailable": 65533
                    }
                }
            }
        }
    }
]
```

Подключил контейнер к сети:

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker network connect lesson23-net demo-web
vadim@TMS-UBUNTU-VM1:~$ sudo docker network inspect lesson23-net --format '{{json .Containers}}'
{"0a78bb17f1f9f7ff42af78578def59cbc2ea4c2525a1e60f8c4dc23693216672":{"Name":"demo-web","EndpointID":"a770ced44ce9b5327861543254d4c0f1d6032a5d46a1cdc652c3f49ffdedc969","MacAddress":"ca:56:37:19:1a:9f","IPv4Address":"172.18.0.2/16","IPv6Address":""}}
```

## Создание второго контейнера того же образа

Создал еще один контейнер сразу подключенный к сети.

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker run -d --name demo-web-2 --network lesson23-net -v lesson23-data:/data alpine:3.20 sleep infinity
6f9cd85b5b0f406a9564074c5a523037eeedaa47438b71a121342118d68a255c

vadim@TMS-UBUNTU-VM1:~$ sudo docker ps -a 
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                         NAMES
6f9cd85b5b0f   alpine:3.20   "sleep infinity"         3 seconds ago    Up 3 seconds                                                  demo-web-2
0a78bb17f1f9   alpine:3.20   "sh -c 'apk add --no…"   11 minutes ago   Up 11 minutes   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp   demo-web
```

Пингуем второй контейнер из первого:

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker exec demo-web ping -c 3 demo-web-2
PING demo-web-2 (172.18.0.3): 56 data bytes
64 bytes from 172.18.0.3: seq=0 ttl=64 time=0.059 ms
64 bytes from 172.18.0.3: seq=1 ttl=64 time=0.081 ms
64 bytes from 172.18.0.3: seq=2 ttl=64 time=0.076 ms

--- demo-web-2 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.059/0.072/0.081 ms
```

И наоборот:

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker exec demo-web-2 ping -c 3 demo-web
PING demo-web (172.18.0.2): 56 data bytes
64 bytes from 172.18.0.2: seq=0 ttl=64 time=0.034 ms
64 bytes from 172.18.0.2: seq=1 ttl=64 time=0.069 ms
64 bytes from 172.18.0.2: seq=2 ttl=64 time=0.060 ms

--- demo-web ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.034/0.054/0.069 ms
```

## Создание файла в volume

Через первый контейнер подключился внутрь. Установил nano и создал файл `shared.txt`

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker exec -it demo-web sh
/ # apk add nano
fetch https://dl-cdn.alpinelinux.org/alpine/v3.20/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.20/community/x86_64/APKINDEX.tar.gz
(1/3) Installing ncurses-terminfo-base (6.4_p20240420-r2)
(2/3) Installing libncursesw (6.4_p20240420-r2)
(3/3) Installing nano (8.0-r0)
Executing busybox-1.36.1-r31.trigger
OK: 9 MiB in 18 packages
/ # nano /data/shared.txt
/ # cat /data/shared.txt 
I was created from demo-web
/ # exit
```

Проверка доступности файла обоим контейнерам:

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker exec demo-web cat /data/shared.txt
I was created from demo-web
vadim@TMS-UBUNTU-VM1:~$ sudo docker exec demo-web-2 cat /data/shared.txt
I was created from demo-web
```

## Остановка контейнеров и очистка образов/volumes/сетей

Остановка и удаление контйнеров:

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker stop demo-web demo-web-2
demo-web
demo-web-2

vadim@TMS-UBUNTU-VM1:~$ sudo docker rm demo-web demo-web-2
demo-web
demo-web-2

vadim@TMS-UBUNTU-VM1:~$ sudo docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

Удаление образов:

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker image ls 
IMAGE         ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:3.20   d9e853e87e55       12.2MB         3.71MB        

vadim@TMS-UBUNTU-VM1:~$ sudo docker rmi d9e853e87e55
Untagged: alpine:3.20
Deleted: sha256:d9e853e87e55526f6b2917df91a2115c36dd7c696a35be12163d44e6e2a4b6bc

vadim@TMS-UBUNTU-VM1:~$ sudo docker image ls 
IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

Удаление volume:

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker volume ls
DRIVER    VOLUME NAME
local     lesson23-data

vadim@TMS-UBUNTU-VM1:~$ sudo docker volume rm lesson23-data
lesson23-data

vadim@TMS-UBUNTU-VM1:~$ sudo docker volume ls
DRIVER    VOLUME NAME
```

Удаление сети:

```bash
vadim@TMS-UBUNTU-VM1:~$ sudo docker network ls
NETWORK ID     NAME           DRIVER    SCOPE
263a43d22825   bridge         bridge    local
be6b134a6ac2   host           host      local
4b35900d5d51   lesson23-net   bridge    local
d9b877a5b3ff   none           null      local

vadim@TMS-UBUNTU-VM1:~$ sudo docker network rm 4b35900d5d51
4b35900d5d51

vadim@TMS-UBUNTU-VM1:~$ sudo docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
263a43d22825   bridge    bridge    local
be6b134a6ac2   host      host      local
d9b877a5b3ff   none      null      local
```