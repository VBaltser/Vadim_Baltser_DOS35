# Python

Создал скрипты по каждому заданию:

# Задание 1. Функция умножнения 

```py
# task1.py
def multiply_numbers(a, b):
    return a * b
```

# Задание 2. Функция чтения из файла 

```py
# task2.py
def task2 ():
    with open("test.txt", "r", encoding="utf-8") as f:
        content = f.read()
    return content
```

# Задание 3. Функция создания директории с файлами 

```py
# task3.py
import os
import shutil

def task3():
    shutil.rmtree("mydir")
    os.mkdir("mydir")
    os.chdir("mydir")

    for filename in ("file1.txt", "file2.txt", "file3.txt"):
        open(filename, "w").close()

    return os.listdir(".")
```

# Задание 4. Генерация html по шаблону 

```py
# task4.py
from jinja2 import Environment, FileSystemLoader
from pathlib import Path

users = [
    {"name": "Иван", "email": "ivan@example.com"},
    {"name": "Мария", "email": "maria@example.com"},
    {"name": "Алексей", "email": "alexey@example.com"},
]

TEMPLATE_DIR = Path(__file__).resolve().parent

def task4():
    env = Environment(loader=FileSystemLoader(TEMPLATE_DIR))
    template = env.get_template("template.html")
    html = template.render(users=users)

    return html
```

Шаблон `template.html`:

```html
<ul>
{% for user in users %}
  <li>{{ user.name }} — {{ user.email }}</li>
{% endfor %}
</ul>
```

# Входная точка с вызовом всех скриптов

```py
# entry.py
from task1 import ( multiply_numbers )
from task2 import ( task2 )
from task3 import ( task3 )
from task4 import ( task4 )

print("Задание 1: ", multiply_numbers(5, 8))
print("Задание 2: ", task2())
print("Задание 3: ", task3())
print("Задание 4: ", task4())
```

Запуск:

```bash
vadim@TMS-UBUNTU-VM1:~/lesson27_python$ python3 entry.py 
Задание 1:  40
Задание 2:  Это тестовый файл для домашнего задания по программированию
Задание 3:  ['file2.txt', 'file3.txt', 'file1.txt']
Задание 4:  <ul>

  <li>Иван — ivan@example.com</li>

  <li>Мария — maria@example.com</li>

  <li>Алексей — alexey@example.com</li>

</ul>
```