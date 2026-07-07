# Lesson 28. Python

## Реализация 
Создал 3 класса:

### Car
Класс самой машины. Содержит ее параметры и методы управления.

Содержит:
- Конструктор с передачей параметров автомобиля (марка, размер бака, расход).
- Методы `ride` - ехать, `refill` - заправить, `info` - вывести информацию

```py
class Car():
    def __init__(self, stamp, fuelTankSize, fuelConsumption):
        self.fuel = 0
        self.stamp = stamp
        self.fuelConsumption = float(fuelConsumption)
        self.fuelTankSize = float(fuelTankSize)
        
    def ride(self, distance):
        if self.fuel < (self.fuelConsumption * distance):
            print("Недостаточно топлива, чтобы проехать это расстояние.")
            print("Остаток топлива: ", self.fuel, "/", self.fuelTankSize)
            print("Запас хода: ", getRangeReserve())
            return
        
        self.fuel = self.fuel - (self.fuelConsumption * distance)

    def refill(self, quantity):
        if quantity > (self.fuelTankSize - self.fuel):
            print("Столько топлива не войдет.")
            print("Остаток топлива: ", self.fuel, "/", self.fuelTankSize)
            return

        self.fuel = self.fuel + quantity

    def info(self):
        print("Марка машины: ", self.stamp)
        print("Расход топлива на единицу расстояния: ", self.fuelConsumption)
        print("Остаток топлива: ", self.fuel, "/", self.fuelTankSize)
```

### CarManager
Класс менеджер машин. Содержит методы создания и выбора машин.

Содержит:
- Конструктор с объявлением пустого массива машин.
- Методы `createCar` - создать новую машину, `showCars` - показать все машины, `selectCar` - выбрать машину  для управления

```py
from car import Car 
import os

class CarManager():
    def __init__(self):
        self.cars = []

    def createCar(self):
        stamp = input("Введите марку: ")
        fuelTankSize = input("Введите размер топливного бака: ")
        fuelConsumption = input("Введите расход топлива на единицу расстояния: ")
        
        self.cars.append(Car(stamp, fuelTankSize, fuelConsumption))

    def showCars(self):
        for i in range(len(self.cars)):
            print("Номер машины: ", i + 1)
            print(self.cars[i].info())

    def selectCar(self):
        index = int(input("Введите номер машины: "))
        self.selectedCar = self.cars[index - 1]
        self.manageCar()

    def askAction(self):
        print("[1] Ехать")
        print("[2] Заправить")
        print("[3] Информация")
        print("[4] Выход")
        
        action = input("Выберите номер действие: ")

        return action

    def handleAction(self, action):
        match action:
            case '1':
                distance = input("Введите расстояние: ")
                self.selectedCar.ride(float(distance))
                return True
            case '2': 
                quantity = input("Введите количество топлива: ")
                self.selectedCar.refill(float(quantity))
                return True
            case '3': 
                self.selectedCar.info()
                return True
            case '4':
                return False 
            case _:
                print("Ошибка ввода действия")
                return True

    def manageCar(self):
        run = True

        while run:
            action = self.askAction()
            os.system("clear")
            run = self.handleAction(action)
```

### Main
Корневой класс. Содержит экземпляр класса CarManager и запрашивает у пользователя действия с ним.

Содержит:
- Конструктор с созданием экземпляра класса CarManager.
- Методы запроса действий

```py
from car_manager import CarManager
import os

class Main():
    def __init__(self):
        self.carManager = CarManager()

    def askAction(self):
        print("")
        print("")
        print("[1] Создать новую машину")
        print("[2] Показать все машины")
        print("[3] Взять машину в управление")
        print("[4] Выход")
        
        action = input("Выберите номер действие: ")

        return action

    def handleAction(self, action):
        match action:
            case '1':
                self.carManager.createCar()
                return True
            case '2': 
                self.carManager.showCars()
                return True
            case '3': 
                self.carManager.showCars()
                self.carManager.selectCar()
                return True
            case '4':
                return False 
            case _:
                print("Ошибка ввода действия")
                return True
```

### Вход скрипта

```py
main = Main()
run = True

while run:
    action = main.askAction()
    os.system("clear")
    run = main.handleAction(action)
```

## Тестирование

Запуск программы и вывод главного меню. Выбираем `[1] Создать новую машину`

```
vadim@TMS-UBUNTU-VM1:~/lesson28_python$ python3 main.py 

[1] Создать новую машину
[2] Показать все машины
[3] Взять машину в управление
[4] Выход
Выберите номер действие: 1
```

Вводим параметры машины и еще раз выбираем `[1] Создать новую машину`:

```
Введите марку: Toyota
Введите размер топливного бака: 60
Введите расход топлива на единицу расстояния: 0.5


[1] Создать новую машину
[2] Показать все машины
[3] Взять машину в управление
[4] Выход
Выберите номер действие: 1
```

Вводим параметры еще одной машины и выбираем `[3] Взять машину в управление`:

```
Введите марку: Nissan
Введите размер топливного бака: 45
Введите расход топлива на единицу расстояния: 0.7


[1] Создать новую машину
[2] Показать все машины
[3] Взять машину в управление
[4] Выход
Выберите номер действие: 3
```

Выводится список машин и запрашивается номер машины, которую необходимо взять в управление. Выбираем машину под номером 1:

```
Номер машины:  1
Марка машины:  Toyota
Расход топлива на единицу расстояния:  0.5
Остаток топлива:  0 / 60.0

Номер машины:  2
Марка машины:  Nissan
Расход топлива на единицу расстояния:  0.7
Остаток топлива:  0 / 45.0

Введите номер машины: 1 
```

Переход в меню управления машиной. Выбираем `[1] Ехать`:

```
[1] Ехать
[2] Заправить
[3] Информация
[4] Выход
Выберите номер действие: 1
```

Вводим расстояние `5`, но в машине нет топлива. Выбираем `[2] Заправить`:

```
Введите расстояние: 5
Недостаточно топлива, чтобы проехать это расстояние.
Остаток топлива:  0 / 60.0
Запас хода:  0.0
[1] Ехать
[2] Заправить
[3] Информация
[4] Выход
Выберите номер действие: 2
```

Вводим количество топлива `20`. Выбираем `[3] Информация`:

```
Введите количество топлива: 20 
[1] Ехать
[2] Заправить
[3] Информация
[4] Выход
Выберите номер действие: 3
```

Видим информацию по машине, что добавилось 20 единиц топлива. Снова выбираем `[1] Ехать`:

```
Марка машины:  Toyota
Расход топлива на единицу расстояния:  0.5
Остаток топлива:  20.0 / 60.0
[1] Ехать
[2] Заправить
[3] Информация
[4] Выход
Выберите номер действие: 1
```

Вводим расстояние `7`. Выбираем `[3] Информация`:

```
Введите расстояние: 7
[1] Ехать
[2] Заправить
[3] Информация
[4] Выход
Выберите номер действие: 3
```

Видим информацию по машине, что потратили 3,5 единицы топлива. Выбираем `[4] Выход`:

```
Марка машины:  Toyota
Расход топлива на единицу расстояния:  0.5
Остаток топлива:  16.5 / 60.0
[1] Ехать
[2] Заправить
[3] Информация
[4] Выход
Выберите номер действие: 4
```

Вернулись в главное меню. Выбираем `[2] Показать все машины`:

```
[1] Создать новую машину
[2] Показать все машины
[3] Взять машину в управление
[4] Выход
Выберите номер действие: 2
```

Видим обновленную информацию по 1 машине.

```
Номер машины:  1
Марка машины:  Toyota
Расход топлива на единицу расстояния:  0.5
Остаток топлива:  16.5 / 60.0

Номер машины:  2
Марка машины:  Nissan
Расход топлива на единицу расстояния:  0.7
Остаток топлива:  0 / 45.0


[1] Создать новую машину
[2] Показать все машины
[3] Взять машину в управление
[4] Выход
Выберите номер действие: 
```