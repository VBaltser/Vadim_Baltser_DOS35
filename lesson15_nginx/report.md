# Создание веб сервера Nginx

## Запуск nginx

Работу выполняю на виртуальной машине c ip `192.168.1.177`.

Установил nginx

`sudo apt install nginx`

Запустил службу

```
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
```

![Скриншот](screens/l15-1.png)

Проверяю доступ с хостовой машины

![Скриншот](screens/l15-2.png)

Веб-сервер доступен 

## Настройка nginx

