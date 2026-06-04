# Урок 16. HTTPS для сайта cookzone.ru на Nginx (Certbot)

У меня уже был куплен домен `cookzone.ru` на `reg.ru`. Буду подключать его к веб-северу из прошлого урока и настраивтаь защищенное подключение.

---

## Настройка DNS на reg.ru

Сейчас домен открывает сайт-заглушку.

![скрин](./screens/l16-1.png)

На сайте reg.ru добавляю ресурсные записи своего публичного IP

![скрин](./screens/l16-2.png)

Настриваю роутер так, чтобы 80 и 443 порты пробрасывались к VM

![скрин](./screens/l16-3.png)

Теперь веб-сервер доступен по публичному IP

![скрин](./screens/l16-4.png)

Через несколько часов обновились DNS записи, по домену стал открываться мой веб сервер:

![скрин](./screens/l16-6.png)

Проверка домена через `dig`:

```bash
dig +short cookzone.ru A 
```

![скрин](./screens/l16-7.png)

---

## Настройка веб-сервера

Создал отдельный каталог для сайта, html странцу скопировал из прошлого урока.

```bash
sudo mkdir -p /var/www/cookzone.ru
sudo cp ~/git/Vadim_Baltser_DOS35/lesson15_nginx/index.html /var/www/cookzone.ru/index.html
sudo chown -R www-data:www-data /var/www/cookzone.ru
```

Настроил nginx-конфиг следующим образом:

```nginx
server {
    listen 80;
    listen [::]:80;

    root /var/www/cookzone.ru;
    server_name cookzone.ru www.cookzone.ru;

    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

---

## Выпуск сертификата

Установил certbot:

```bash
sudo apt update
sudo apt install certbot python3-certbot-nginx -y
certbot --version
```

![скрин](./screens/l16-5.png)

Выпуск сертификата:

```bash
sudo certbot --nginx -d cookzone.ru
```

![скрин](./screens/l16-8.png)

После этого certbot сам поменял nginx-конфиг:

![скрин](./screens/l16-9.png)

Теперь работает подключение через HTTPS к веб серверу

![скрин](./screens/l16-10.png)

## Автоматическое продление сертификата

Certbot сам поставил systemd-таймер:

```bash
systemctl list-timers | grep certbot
systemctl cat certbot.timer
```

![скрин](./screens/l16-11.png)