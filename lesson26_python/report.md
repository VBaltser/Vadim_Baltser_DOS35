# Python

## Задание

Написать скрипт, который принимает на вход строку и выводит на экран количество букв в верхнем регистре, количество букв в нижнем регистре, количество цифр и количество символов пунктуации.

### Реализация

Решил делать подсчет через регулярные выражения:

Для букв в верхнем регистре: `[A-Z]`
Для букв в верхнем регистре: `[a-z]`
Для цифр: `\d`
Для символов пунктуации: `[!\"#$%&'()*+,\-./:;<=>?@\[\\\]^_`{|}~]`

Скрипт содержит функцию `count_by_regex`, которая считает количество символов в строке по переданному регулярному выражению. И функции для подсчета каждой группы символов.

Создал 3 файла:

1) Содержит только функции подсчета, для удобства покрытия тестами. 

```py
# symbol_parser.py
import re

def count_by_regex(pattern, string):
    matches = re.findall(pattern, string)
    return len(matches)

def count_uppercase(string):
    return count_by_regex(r"[A-Z]", string)

def count_lowercase(string):
    return count_by_regex(r"[a-z]", string)

def count_digit(string):
    return count_by_regex(r"\d", string)

def count_punctuation(string):
    return count_by_regex(r"[!\"#$%&'()*+,\-./:;<=>?@\[\\\]^_`{|}~]", string)
```

2) cli для логикой ввода/вывода

```py
# symbol_parser_cli.py
from symbol_parser import (
    count_digit,
    count_lowercase,
    count_punctuation,
    count_uppercase,
)

text = input("Введите произвольную строку: ")

print("Количество букв в верхнем регистре: ", count_uppercase(text))
print("Количество букв в нижнем регистре: ", count_lowercase(text))
print("Количество цифр: ", count_digit(text))
print("Количество символов пунктуации: ", count_punctuation(text))
```

3) Тесты 

С помощью ИИ сгенерировал тесты для функций из `symbol_parser.py`

```py
# test_symbol_parser.py
import unittest

from symbol_parser import (
    count_by_regex,
    count_digit,
    count_lowercase,
    count_punctuation,
    count_uppercase,
)


class TestCountByRegex(unittest.TestCase):
    def test_counts_single_char_matches(self):
        self.assertEqual(count_by_regex(r"\d", "a1b2c3"), 3)

    def test_returns_zero_when_no_matches(self):
        self.assertEqual(count_by_regex(r"\d", "abc"), 0)

    def test_empty_string(self):
        self.assertEqual(count_by_regex(r"[A-Z]", ""), 0)


class TestCountUppercase(unittest.TestCase):
    def test_mixed_string_from_report(self):
        self.assertEqual(count_uppercase("aaaAAAAA123%^&*"), 5)

    def test_only_uppercase(self):
        self.assertEqual(count_uppercase("HELLO"), 5)

    def test_no_uppercase(self):
        self.assertEqual(count_uppercase("hello123"), 0)


class TestCountLowercase(unittest.TestCase):
    def test_mixed_string_from_report(self):
        self.assertEqual(count_lowercase("aaaAAAAA123%^&*"), 3)

    def test_only_lowercase(self):
        self.assertEqual(count_lowercase("hello"), 5)

    def test_no_lowercase(self):
        self.assertEqual(count_lowercase("HELLO123"), 0)


class TestCountDigit(unittest.TestCase):
    def test_mixed_string_from_report(self):
        self.assertEqual(count_digit("aaaAAAAA123%^&*"), 3)

    def test_only_digits(self):
        self.assertEqual(count_digit("12345"), 5)

    def test_no_digits(self):
        self.assertEqual(count_digit("abcABC"), 0)


class TestCountPunctuation(unittest.TestCase):
    def test_mixed_string_from_report(self):
        self.assertEqual(count_punctuation("aaaAAAAA123%^&*"), 4)

    def test_common_punctuation(self):
        self.assertEqual(count_punctuation("Hello, world!"), 2)

    def test_no_punctuation(self):
        self.assertEqual(count_punctuation("HelloWorld123"), 0)


class TestCombined(unittest.TestCase):
    def test_empty_string(self):
        self.assertEqual(count_uppercase(""), 0)
        self.assertEqual(count_lowercase(""), 0)
        self.assertEqual(count_digit(""), 0)
        self.assertEqual(count_punctuation(""), 0)

    def test_spaces_are_not_counted(self):
        text = "A b 1 !"
        self.assertEqual(count_uppercase(text), 1)
        self.assertEqual(count_lowercase(text), 1)
        self.assertEqual(count_digit(text), 1)
        self.assertEqual(count_punctuation(text), 1)

    def test_all_categories_together(self):
        text = "Ab1!"
        self.assertEqual(count_uppercase(text), 1)
        self.assertEqual(count_lowercase(text), 1)
        self.assertEqual(count_digit(text), 1)
        self.assertEqual(count_punctuation(text), 1)


if __name__ == "__main__":
    unittest.main()
```

### Тесты

```bash
vadim@TMS-UBUNTU-VM1:~/lesson26_python$ python3 symbol_parser_cli.py 
Введите произвольную строку: aaaAAAAA123%^&*
Количество букв в верхнем регистре:  5
Количество букв в нижнем регистре:  3
Количество цифр:  3
Количество символов пунктуации:  4
```

Запуск unit-тестов

```bash
vadim@TMS-UBUNTU-VM1:~/lesson26_python/symbol_parser$ python3 -m unittest test_symbol_parser.py -v
test_all_categories_together (test_symbol_parser.TestCombined.test_all_categories_together) ... ok
test_empty_string (test_symbol_parser.TestCombined.test_empty_string) ... ok
test_spaces_are_not_counted (test_symbol_parser.TestCombined.test_spaces_are_not_counted) ... ok
test_counts_single_char_matches (test_symbol_parser.TestCountByRegex.test_counts_single_char_matches) ... ok
test_empty_string (test_symbol_parser.TestCountByRegex.test_empty_string) ... ok
test_returns_zero_when_no_matches (test_symbol_parser.TestCountByRegex.test_returns_zero_when_no_matches) ... ok
test_mixed_string_from_report (test_symbol_parser.TestCountDigit.test_mixed_string_from_report) ... ok
test_no_digits (test_symbol_parser.TestCountDigit.test_no_digits) ... ok
test_only_digits (test_symbol_parser.TestCountDigit.test_only_digits) ... ok
test_mixed_string_from_report (test_symbol_parser.TestCountLowercase.test_mixed_string_from_report) ... ok
test_no_lowercase (test_symbol_parser.TestCountLowercase.test_no_lowercase) ... ok
test_only_lowercase (test_symbol_parser.TestCountLowercase.test_only_lowercase) ... ok
test_common_punctuation (test_symbol_parser.TestCountPunctuation.test_common_punctuation) ... ok
test_mixed_string_from_report (test_symbol_parser.TestCountPunctuation.test_mixed_string_from_report) ... ok
test_no_punctuation (test_symbol_parser.TestCountPunctuation.test_no_punctuation) ... ok
test_mixed_string_from_report (test_symbol_parser.TestCountUppercase.test_mixed_string_from_report) ... ok
test_no_uppercase (test_symbol_parser.TestCountUppercase.test_no_uppercase) ... ok
test_only_uppercase (test_symbol_parser.TestCountUppercase.test_only_uppercase) ... ok

----------------------------------------------------------------------
Ran 18 tests in 0.002s

OK
```