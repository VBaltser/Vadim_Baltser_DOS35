# Урок 16. HTTPS для сайта cookzone.ru на Nginx (Certbot)

Работу выполняю на той же виртуальной машине, что и в уроке 15 (локальный IP `192.168.1.177`).  
Nginx уже установлен и запущен. В этом уроке создаю сайт для домена **cookzone.ru** (куплен на [reg.ru](https://www.reg.ru/)) и подключаю SSL через Certbot.

---

## Настройка DNS на reg.ru

1. Войти в личный кабинет reg.ru → домен **cookzone.ru** → **DNS-серверы и управление зоной** (или «Редактор DNS»).
2. Убедиться, что домен использует DNS reg.ru (не сторонние NS, если зона редактируется там).
3. Добавить или изменить записи:

| Тип | Имя (хост) | Значение | TTL |
|-----|------------|----------|-----|
| `A` | `@` | `<публичный_IP_вашего_роутера>` | 300–3600 |
| `A` | `www` | `<публичный_IP_вашего_роутера>` | 300–3600 |

`<публичный_IP_вашего_роутера>` — внешний IP, который виден в интернете (не `192.168.1.177`). Его можно посмотреть на роутере или на сайте вроде [2ip.ru](https://2ip.ru/).

4. На роутере настроить **проброс портов** (Port Forwarding) на VM:
   - TCP `80` → `192.168.1.177:80`
   - TCP `443` → `192.168.1.177:443`

5. Дождаться обновления DNS (обычно от нескольких минут до часа) и проверить:

```bash
dig +short cookzone.ru A
dig +short www.cookzone.ru A
```

Оба запроса должны вернуть ваш публичный IP.

> **Важно:** Let's Encrypt обращается к домену из интернета. Запись только в `/etc/hosts` на VM или Windows **не подходит** для выпуска сертификата — нужны публичные A-записи и доступные снаружи порты 80 и 443.

![Скриншот — записи DNS cookzone.ru в reg.ru](./screens/l16-0.png)

---

## Подготовка: сайт cookzone.ru на Nginx (HTTP)

### Каталог и страница

```bash
sudo mkdir -p /var/www/cookzone.ru
sudo cp ~/git/Vadim_Baltser_DOS35/lesson15_nginx/index.html /var/www/cookzone.ru/index.html
sudo chown -R www-data:www-data /var/www/cookzone.ru
```

### Конфиг виртуального хоста

Файл `/etc/nginx/sites-available/cookzone.ru`:

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

Включение сайта и проверка:

```bash
sudo ln -sf /etc/nginx/sites-available/cookzone.ru /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

Проверка по HTTP:

```bash
curl -I http://cookzone.ru
curl -I http://www.cookzone.ru
```

![Скриншот — сайт cookzone.ru по HTTP](./screens/l16-2.png)

---

## Шаг 1. Установка Certbot

По [инструкции Certbot](https://certbot.eff.org/) для Nginx на Ubuntu:

```bash
sudo apt update
sudo apt install certbot python3-certbot-nginx -y
certbot --version
```

![Скриншот — установка Certbot](./screens/l16-1.png)

---

## Шаг 2. Запуск Certbot и запрос сертификата

Certbot сам создаёт CSR и отправляет запрос на подпись (Let's Encrypt).

Для домена и поддомена `www`:

```bash
sudo certbot --nginx -d cookzone.ru -d www.cookzone.ru
```

Только для основного домена:

```bash
sudo certbot --nginx -d cookzone.ru
```

В диалоге указать:

- email для уведомлений (можно почту reg.ru);
- согласие с Terms of Service;
- редирект HTTP → HTTPS (обычно вариант **Redirect**).

![Скриншот — успешный выпуск сертификата](./screens/l16-3.png)

---

## Шаг 3. Получение подписанного сертификата

После успешного `certbot` сертификат и ключ лежат в:

```bash
sudo ls -la /etc/letsencrypt/live/cookzone.ru/
```

Основные файлы:

| Файл | Назначение |
|------|------------|
| `fullchain.pem` | сертификат + цепочка CA |
| `privkey.pem` | приватный ключ |
| `cert.pem` | сертификат домена |
| `chain.pem` | промежуточные сертификаты |

Просмотр срока действия:

```bash
sudo certbot certificates
```

![Скриншот — список сертификатов certbot certificates](./screens/l16-4.png)

---

## Шаг 4. Установка SSL на веб-сервер

При запуске `certbot --nginx` плагин обычно **сам** добавляет в конфиг `listen 443 ssl`, пути к сертификатам и редирект с 80 на 443.

Проверить изменения в конфиге:

```bash
sudo cat /etc/nginx/sites-available/cookzone.ru
```

Применить конфигурацию:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

Убедиться, что Nginx слушает 443:

```bash
ss -tlnp | grep -E ':80|:443'
```

![Скриншот — фрагмент конфига с ssl_certificate](./screens/l16-5.png)

---

## Шаг 5. Проверка HTTPS в браузере

Открыть в браузере:

- `https://cookzone.ru`
- `https://www.cookzone.ru`

Убедиться:

- страница открывается;
- соединение защищено (замок);
- сертификат выдан Let's Encrypt, домен **cookzone.ru**.

Проверка из терминала:

```bash
curl -I https://cookzone.ru
curl -I https://www.cookzone.ru
```

![Скриншот — cookzone.ru по HTTPS в браузере](./screens/l16-6.png)

![Скриншот — curl -I https://cookzone.ru](./screens/l16-7.png)

---

## Шаг 6. Автоматическое продление сертификата

Certbot на Ubuntu обычно ставит systemd-таймер:

```bash
systemctl list-timers | grep certbot
```

Тест продления без реального обновления:

```bash
sudo certbot renew --dry-run
```

При успехе сертификат для **cookzone.ru** будет продлеваться автоматически до истечения срока.

![Скриншот — certbot renew --dry-run](./screens/l16-8.png)

---

## Возможные ошибки

| Симптом | Что проверить |
|---------|----------------|
| `Connection refused` / timeout при certbot | проброс 80/443 на роутере, firewall на VM (`sudo ufw status`) |
| домен не проходит проверку | A-записи `@` и `www` в reg.ru, `dig cookzone.ru` |
| открывается чужой сайт / старая страница | кэш DNS, подождать TTL, проверить IP в A-записи |
| nginx: configuration test failed | `sudo nginx -t`, конфликт `default_server` с сайтом `tms.by` |
| renew падает | `sudo journalctl -u certbot`, повторить `--dry-run` |

---

## Вывод

На reg.ru настроены DNS-записи для **cookzone.ru**, создан виртуальный хост на Nginx, установлен Certbot, получен и подключён SSL-сертификат Let's Encrypt, сайт доступен по HTTPS, настроено автоматическое продление.
