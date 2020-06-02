SELECT * FROM Car_Market
SELECT * FROM Cars


CREATE TABLE Cars 
		  (id INT PRIMARY KEY,
		   brand VARCHAR(10) NOT NULL,
		   model VARCHAR(15) NOT NULL,
		   type VARCHAR(15) CHECK (type IN ('Off roader', 'Luxury', 'Standart', 'Sport')),
		   carPower INT NOT NULL CHECK (carPower > 0),
		   yearOfCar INT CHECK (yearOfCar > 1800),
		   start_price MONEY NOT NULL CHECK (start_price > 0))


CREATE TABLE Car_Market 
			(id INT PRIMARY KEY NOT NULL,
			 car_id INT REFERENCES Cars (id) NOT NULL, 
			 price MONEY CHECK (price > 0),
			 numberOfOwners INT NULL,
			 condition VARCHAR(10) CHECK (condition IN ('bad', 'normal', 'good')),
			 dealershipName VARCHAR(15) NOT NULL)




1. ������� �������������� Sports Cars. �������: �����, ������
SELECT brand, model
FROM Cars
WHERE type = 'Sport'

2.    ����� ��� �/� ���������� 2008 ���� �������.

SELECT *
FROM Cars JOIN Car_Market ON car_id = Cars.id
WHERE (yearOfCar = 2008 AND numberOfOwners IS NOT NULL)

3.    ������� ����� �����������, ������� �� ����������� � 2007 ����.

SELECT brand
FROM Cars
group by brand
HAVING MAX(yearOfCar) <= 2007


4.    ����� ���� ��������������, ������� ��������� � Off Roaders, � Luxory cars.

SELECT brand FROM Cars
WHERE type = 'Luxury'
	INTERSECT
SELECT brand FROM Cars
WHERE type = 'Off roader'


5.    ����� ��� ����������, ��������� ������������ ���� � ����� �����. ������� �������� ������ � ���������� �������������� �����.

ALTER VIEW BrandsAndDealershipNames AS
SELECT brand, dealershipName
FROM Cars JOIN Car_Market ON car_id = Cars.id
GROUP BY brand, dealershipName

SELECT dealershipName, COUNT(*) as Count 
FROM BrandsAndDealershipNames
GROUP BY dealershipName
HAVING COUNT(*) >= 3

6.    ����� ����������, ������� �� ��������� �/�. ������� �����, ������.


CREATE VIEW New_Cars AS
SELECT car_id, model, brand
FROM Cars JOIN Car_Market ON car_id = Cars.id
WHERE numberOfOwners IS NULL

CREATE VIEW Old_Cars AS
SELECT car_id, model, brand
FROM Cars JOIN Car_Market ON car_id = Cars.id
WHERE numberOfOwners IS NOT NULL

SELECT model, brand
FROM New_Cars
	EXCEPT
SELECT model, brand
FROM Old_Cars

7.    ������� �/� ����������, ������� �������� � ���� (�������� � �����������) ����� 20%.  ������� �����, ���� ������ ���������� � ���� �/� ����������.

SELECT brand, model, MIN(price) AS Min_price, start_price AS Start_price
FROM Cars JOIN Car_Market ON car_id = Cars.id
GROUP BY brand, model, start_price
HAVING start_price * 0.8 > MIN(price)


8.    ������� ����������� ��������� � �������� ����������, ��� ����� ���������� ����������� (Off Roaders)�� 30000 (�� �����).

SELECT TOP(1) price,dealershipName
FROM Cars JOIN Car_Market ON car_id = Cars.id
WHERE type = 'Off roader' AND price <= 30000 AND numberOfOwners IS NULL
ORDER BY price

9.    ����� ���������� ������� � ������� ���� ��� ������� ������ ����� (�� �����). ������� �����, ���������� ������� � ����. ������ � ������ ��������.

SELECT type, CAST(AVG(start_price) as INT) AS Average_price
FROM Cars
GROUP BY type
ORDER BY Average_price DESC


10.  ����� ������ �����������, � ������� ����������� ���� ���������� �� ������������ � 2 � ����� ����.

SELECT brand, model
FROM Cars JOIN Car_Market ON car_id = Cars.id
GROUP BY model, brand
HAVING MIN(price) * 2 <= MAX(price)

11.  ������� �������������, ������������ ������������, �� �� ������������ ���������� ������.

SELECT brand FROM Cars
WHERE type = 'Off roader'
	EXCEPT
SELECT brand FROM Cars
WHERE type = 'Sport'
9500000,00
95000000,00

12.  ����� ���� ����� �/� ����� ���������� ������ ����� Toyota?

SELECT
(SELECT CAST(COUNT(*) AS REAL) 
FROM Cars JOIN Car_Market ON car_id = Cars.id
WHERE numberOfOwners IS NOT NULL AND brand = 'Toyota') 
	/ 
(SELECT CAST(COUNT(*) AS REAL) 
FROM Cars JOIN Car_Market ON car_id = Cars.id
WHERE numberOfOwners IS NOT NULL)


13.  ����� �������� ���������� ���������� ��� ������� ������ (�� ���������� �������������� �/� �����������). ������� ����� � ������.
CREATE VIEW All_Cars AS
SELECT brand, model, type, COUNT(*) AS Count
FROM Cars JOIN Car_Market ON car_id = Cars.id
WHERE (numberOfOwners IS NOT NULL)
GROUP BY brand, model, type

SELECT brand, model, All_Cars.type 
FROM All_Cars 
	JOIN
(SELECT type, MAX(Count) AS Max_Count
FROM All_Cars
GROUP BY type) S1
ON Max_Count = Count AND S1.type = All_Cars.type



�������/�������������
����� ����� ������� ������ � ����� ������� ��� ������� ������. ������� ��������� � ���� ������� � ������: �����, ����� ������� ������ (����, �����, ������) � ����� ������� ������ (����, �����, ������).

ALTER VIEW Cars_With_Max_price AS
SELECT Cars.type, brand, model, price
FROM Cars JOIN Car_Market ON car_id = Cars.id
	JOIN
(SELECT type, MAX(price) AS Max_price
FROM Cars JOIN Car_Market ON car_id = Cars.id
GROUP BY type) S1
ON Car_Market.price = S1.Max_price AND Cars.type = S1.type

ALTER VIEW Cars_With_Min_price AS
SELECT Cars.type, brand, model, price
FROM Cars JOIN Car_Market ON car_id = Cars.id
	JOIN
(SELECT type, MIN(price) AS Max_price
FROM Cars JOIN Car_Market ON car_id = Cars.id
GROUP BY type) S1
ON Car_Market.price = S1.Max_price AND Cars.type = S1.type

SELECT Cars_With_Max_price.*, Cars_With_Min_price.brand, Cars_With_Min_price.model, Cars_With_Min_price.price
FROM Cars_With_Max_price
	JOIN
Cars_With_Min_price
ON Cars_With_Max_price.type = Cars_With_Min_price.type

SELECT * FROM Cars_With_Max_price

SELECT * FROM Cars_With_Min_price

���������� �������� ������� ��� �� ����������. ������� ��� ������, ��������� �� ��������� �����, � ������� �������� �������� ������� ����.
(������� � ���� �� ���) --


SELECT * FROM Cars JOIN Car_Market ON car_id = Cars.id

ALTER FUNCTION GET_CARS_STATISTIC ()
RETURNS @table TABLE(brand VARCHAR(10), model VARCHAR(10), Speed real) AS
BEGIN
	DECLARE @Current_year INT
	SET @Current_year = YEAR(GETDATE())
	INSERT INTO @table
		SELECT brand, model, AVG((start_price - price) / (@Current_year - yearOfCar + 1)) AS SPEED
		FROM Cars JOIN Car_Market ON car_id = Cars.id
		GROUP BY brand, model
		RETURN
END;

SELECT * FROM GET_CARS_STATISTIC() ORDER BY Speed DESC

INSERT INTO Car_Market VALUES(15, 2, 1800000, NULL, 'good', 'GoodCars')

DELETE FROM Car_Market WHERE id = 15



�������
��� ������� ����� ������ ������ ���������� ��������� ��������� �/� ����������� ��� �� ������ �� 5%.

ALTER TRIGGER Cars_sales ON Cars
AFTER INSERT AS
BEGIN
	DECLARE @New_car_model VARCHAR(15)
	SELECT @New_car_model = (SELECT model FROM inserted)
	
	print @New_car_model

	UPDATE Car_Market
	SET price *= 0.95 
	WHERE id IN (SELECT Car_Market.id 
				 FROM Cars JOIN Car_Market ON car_id = Cars.id
				 WHERE model = @New_car_model)
END

SELECT * 
FROM Cars JOIN Car_Market ON car_id = Cars.id
WHERE model = 'Priora'

SELECT * FROM Cars



INSERT INTO Cars VALUES(16, 'Lada', 'Priora', 'Standart',  390, 2018, 505000)

DELETE FROM Cars WHERE id = 16


		

SELECT * FROM Cars JOIN Car_Market ON car_id = Cars.id

INSERT INTO Cars VALUES(1, 'BMW', 'X5', 'Off roader', 286, 2015, 1500000)
INSERT INTO Cars VALUES(2, 'BMW', 'M5', 'Sport', 286, 2016, 1800000)
INSERT INTO Cars VALUES(3, 'BMW', 'i8', 'Luxury', 386, 2019, 9500000)

INSERT INTO Cars VALUES(4, 'Toyota', 'Camry', 'Standart',  250, 2007, 7500000)
INSERT INTO Cars VALUES(5, 'Toyota', '�orolla', 'Standart',  230, 2006, 6500000)
INSERT INTO Cars VALUES(6, 'Toyota', 'RAV4', 'Off roader',  230, 2012, 6500000)
INSERT INTO Cars VALUES(7, 'Bentley', 'X2', 'Luxury',  350, 2018,7500000)

INSERT INTO Cars VALUES(8, 'Lada', 'Priora', 'Standart',  180, 2002, 100000)
INSERT INTO Cars VALUES(9, 'Lada', '4', 'Off roader',  160, 1997, 20000)
INSERT INTO Cars VALUES(10, 'Lada', 'Patriot', 'Off roader',  170, 2008, 25000)

INSERT INTO Cars VALUES(11, 'Mercedes', 'C5', 'Sport', 256, 2008, 3800000)
INSERT INTO Cars VALUES(12, 'Mercedes', 'CLA', 'Sport', 286, 2017, 5800000)
INSERT INTO Cars VALUES(13, 'Mercedes', 'Maybach', 'Luxury', 316, 2020, 13800000)

INSERT INTO Cars VALUES(14, 'Tank', '123', 'Standart',  180, 2002, 100000)


INSERT INTO Car_Market VALUES(1, 1, 1000000, 3, 'normal', 'GoodCars')
INSERT INTO Car_Market VALUES(2, 2, 1500000, 2, 'good', 'GoodCars')
INSERT INTO Car_Market VALUES(3, 2, 500000, 6, 'bad', 'GoodCars')
INSERT INTO Car_Market VALUES(4, 2, 800000, 1, 'normal', 'GoodCars')
INSERT INTO Car_Market VALUES(5, 3, 9500000, NULL, 'good', 'GoodCars')
INSERT INTO Car_Market VALUES(6, 4, 4500000, NULL, 'good', 'GoodCars')

INSERT INTO Car_Market VALUES(7, 8, 80000, 4, 'bad', 'RussianCars')
INSERT INTO Car_Market VALUES(8, 8, 65000, 3, 'normal', 'RussianCars')
INSERT INTO Car_Market VALUES(9, 9, 10000, 9, 'bad', 'RussianCars')
INSERT INTO Car_Market VALUES(10, 10, 22000, 1, 'good', 'RussianCars')

INSERT INTO Car_Market VALUES(11, 11, 500000, 6, 'bad', 'FastCars')
INSERT INTO Car_Market VALUES(12, 12, 4800000, 2, 'normal', 'FastCars')
INSERT INTO Car_Market VALUES(13, 12, 5800000, NULL, 'good', 'FastCars')
INSERT INTO Car_Market VALUES(14, 13, 10000000, 2, 'good', 'FastCars')
INSERT INTO Car_Market VALUES(15, 12, 4800000, 1, 'good', 'FastCars')
INSERT INTO Car_Market VALUES(16, 9, 29000, NULL, 'good', 'RussianCars')

INSERT INTO Car_Market VALUES(17, 5, 4500000, 2, 'normal', 'GoodCars')
INSERT INTO Car_Market VALUES(18, 6, 1500000, 2, 'normal', 'GoodCars')
INSERT INTO Car_Market VALUES(19, 7, 6500000, 1, 'normal', 'GoodCars')
INSERT INTO Car_Market VALUES(20, 14, 10000, 1, 'good', 'RussianCars')

