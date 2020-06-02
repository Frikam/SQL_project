**В файле Project.sql хранятся запросы и создание таблиц**

# Описание технического задания

# Авторынок

 

Вам необходимо хранить информацию о б/у автомобилях.

Для этого храним описание авто в отдельной таблице (марка, модель,  мощность, доступные цвета, комплектация и т.п. + цена на начало продаж).

Информацию о б/у автомобилях хранить со ссылкой на новые + информация об автомобиле (цена, кол-во владельцев, состояние и пр.)

Также потребуется информация о типе автомобиля (представительский, внедорожник, мини, спортивный и пр.)

Проанализируйте функциональные зависимости и продумайте нормализованную схему базы данных. Создайте требуемые таблицы с подходящими типами полей, не забудьте про ограничение целостности и внешние связи.

 

### Запросы

 

1. Найдите производителей Sports Cars. Вывести: марка, модель

2. Найти все б/у автомобили 2008 года выпуска.

3. Найдите марки автомобилей, которые не обновлялись с 2007 года.

4. Найти всех производителей, которые выпускают и Off Roaders, и Luxory cars.

5. Найти все автосалоны, торгующие автомобилями трех  и более марок. Вывести название салона и количество представленных марок.

6. Найти автомобили, которые не продаются б/у. Вывести марку, модель.

7. Найдите б/у автомобили, которые потеряли в цене (сравнить с минимальной) более 20%.  Вывести марку, цену нового автомобиля и цену б/у автомобиля.

8. Найдите минимальную стоимость и название автосалона, где можно посмотреть внедорожник (Off Roaders)до 30000 (из новых).

9. Найти количество моделей и среднюю цену для каждого класса машин (из новых). Вывести класс, количество моделей и цену. Начать с самого дорогого.

10. Найти модели автомобилей, у которых минимальная цена отличается от максимальной в 2 и более раза.

11. Найдите производителя, выпускающего внедорожники, но не выпускающего спортивные машины.

12. Какую долю среди б/у машин составляют машины марки Toyota?

13. Найти наиболее популярный автомобиль для каждого класса (по количеству представленных б/у автомобилей). Вывести марку и модель.

 

### Функции/представления

Найти самую дорогую машину и самую дешевую для каждого класса. Вывести результат в виде таблицы я полями: класс, самая дорогая машина (цена, марка, модель) и самая дешевая машина (цена, марка, модель).

 

Проследить динамику падения цен на автомобиль. Вывести все модели, имеющиеся на вторичном рынке, в порядке убывания скорости падения цены.

 

### Триггер

При выпуске новой версии модели автомобиля уменьшить стоимость б/у автомобилей той же модели на 5%.