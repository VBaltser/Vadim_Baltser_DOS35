# Lesson 2

## Task 0. Подключение Git-репозитория.
1) Создал SSH-ключ в guthub.
2) Создал файл с ssh-ключом `git_tms` в `/home/vadim/ssh/git_tms`
3) Создал config-файл в .ssh
```
Host github.com
    HostName github.com
    User git
    IdentityFile /home/vadim/ssh/git_tms
    IdentitiesOnly yes
```
4) Проверяем доступ к репозиторию:

```ssh -T git@github.com```

![Скриншот](task0/l2-t0-1.png)

## Task 1. 5-10 коммитов
Создал 7 коммитов с js-файлами:

`git log --oneline --decorate -15`

![Скриншот](task1/l2-t1-1.png)
