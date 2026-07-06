# Python

pyhton3 уже установлен на VM с уроков по ansible.

```bash
vadim@TMS-UBUNTU-VM1:~$ python3 --version
Python 3.14.4
```

## Первая программа "Hello, world"

Создал файл `hello.py` с содержимым:

```py
print("hello, world!")
```

Запуск:

```bash
vadim@TMS-UBUNTU-VM1:~/lesson25_python$ python3 hello.py 
hello, world!
```

## Результат вычисления

Изменил содержимое файла `hello.py`:

```py
a = 2
b = 2
sum = a + b
print(sum)
```

Запуск:

```bash
vadim@TMS-UBUNTU-VM1:~/lesson25_python$ python3 hello.py 
4
```

## Среднее арифметическое двух введенных чисел

Создал файл `avg.py` с содержимым:

```py
def read_number(prompt):
    while True:
        text = input(prompt)
        try:
            return float(text)
        except ValueError:
            print("Ошибка: введите число")

number1 = read_number("Введите число 1: ")
number2 = read_number("Введите число 2: ")

avg = (number1 + number2) / 2

print("Среднее арифметическое: ", avg)
```

Скрипт содержит функцию, которая запрашивает у пользователя число с проверкой ввода.
Скрипт запрашивает 2 числа и выводит среднее арифметическое.

```bash
vadim@TMS-UBUNTU-VM1:~/lesson25_python$ python3 avg.py 
Введите число 1: hello
Ошибка: введите число
Введите число 1: 18.66
Введите число 2: 12
Среднее арифметическое:  15.33
```