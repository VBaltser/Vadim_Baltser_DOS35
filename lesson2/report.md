# Lesson 2

## Task 0. Подключение Git-репозитория.
1) Создал SSH-ключ в github.
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

![Скриншот](screens/l2-t0-1.png)

## Task 1. 5-10 коммитов
Создал 7 коммитов с js-файлами:

`git log --oneline --decorate -15`

![Скриншот](screens/l2-t1-1.png)

## Task 2. Reflog
``` 
git log --oneline -5
git reflog -10
git reset --hard HEAD~1
git log --oneline -5
git reflog -10
git reset --hard 'HEAD@{1}'
git log --oneline -5
git reflog -10
```

![Скриншот](screens/l2-t2-1.png)

## Task 3. New branch

```
git checkout -b develop
git branch -vv
```
![Скриншот](screens/l2-t3.png)

## Task 4. Ammend

```
echo "export " >> lesson2/task1/shell-sort.js
git add lesson2/task1/shell-sort.js
git commit -m "edit shell-sort"

echo "default shellSort;" >> lesson2/task1/shell-sort.js
git add lesson2/task1/shell-sort.js
git commit --amend --no-edit
git show --stat
```

![Скриншот](screens/l2-t4.png)