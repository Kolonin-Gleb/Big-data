-- Глава 4. Запросы

-- DISTINCT = для уникальных значений

CREATE TABLE Products2
(
	Id Serial PRIMARY KEY,
	ProductName VARCHAR(30) NOT NULL,
	Manufacturer VARCHAR(20) NOT NULL,
	ProductCount INTEGER DEFAULT 0,
	Price NUMERIC
);

-- Аналог DESCRIBE TABLE в PostgreSQL
-- SELECT * FROM information_schema.columns WHERE table_name = '<Products>';


-- Является ли Postgre регистрозависимой?
-- Нет. Все названия приводятся в нижний регистр.

INSERT INTO products (ProductName, manufacturer, productcount, price)
Values
('iPhone X', 'Apple', 2, 71000),
('iPhone 8', 'Apple', 3, 56000),
('Galaxy S9', 'Samsung', 6, 56000),
('Galaxy S8 Plus', 'Samsung', 2, 46000),
('Desire 12', 'HTC', 3, 26000);

-- Выборка уникальных производителей
SELECT DISTINCT manufacturer FROM products;

-- ORDER BY = для сортировки

-- Сортировка по убыванию цены всех имеющихся товаров
SELECT productname, productcount * price as totalSum
FROM products
ORDER BY totalSum DESC;


-- LIMIT и OFFSET = Получение диапозона строк
-- LIMIT - выдать не более ...
-- OFFSET - выдать начиная с ...

SELECT * FROM products order by productname;

SELECT * FROM products Order by productname Offset 2 Limit 2;


-- Агрегатные функции

-- Объединение строковых значений, как CONCAT

SELECT STRING_AGG(productname, '| ') FROM Products;


-- Группировка GROUP BY HAVING

-- Добавление столбца в таблицу
ALTER TABLE products
ADD IsDiscounted BOOL;

-- Группировка по производителю, чтобы понять сколько разных товаров от каждого из них имеется
SELECT * FROM products order by productname;
-- Не смог повторить, т.к. нет данных для вставки из статьи



-- Подзапросы

DROP TABLE products;

CREATE TABLE Products
(
    Id SERIAL PRIMARY KEY,
    ProductName VARCHAR(30) NOT NULL,
    Company VARCHAR(20) NOT NULL,
    ProductCount INTEGER DEFAULT 0,
    Price NUMERIC NOT NULL
);
CREATE TABLE Customers
(
    Id SERIAL PRIMARY KEY,
    FirstName VARCHAR(30) NOT NULL
);

-- Зависимая таблица с внешними ключами
-- При удалении данных, на которые ссылаются поля они также будут удалены
CREATE TABLE Orders
(
	Id SERIAL PRIMARY KEY,
	ProductId INTEGER NOT NULL REFERENCES Products(Id) ON DELETE CASCADE,
	CustomerId INTEGER NOT NULL REFERENCES Customers(Id) ON DELETE CASCADE,
	CreatedAt DATE NOT NULL,
	ProductCount INTEGER DEFAULT 1,
	Price NUMERIC NOT NULL
);


INSERT INTO Products(ProductName, Company, ProductCount, Price) 
VALUES ('iPhone X', 'Apple', 2, 66000),
('iPhone 8', 'Apple', 2, 51000),
('iPhone 7', 'Apple', 5, 42000),
('Galaxy S9', 'Samsung', 2, 56000),
('Galaxy S8 Plus', 'Samsung', 1, 46000),
('Nokia 9', 'HDM Global', 2, 26000),
('Desire 12', 'HTC', 6, 38000);

INSERT INTO Customers(FirstName) 
VALUES ('Tom'), ('Bob'),('Sam');

-- Вставка данных в таблицу с внешними ключами с помощью вложенных запросов
INSERT INTO Orders(ProductId, CustomerId, CreatedAt, ProductCount, Price) 
VALUES
( 
    (SELECT Id FROM Products WHERE ProductName='Galaxy S9'), 
    (SELECT Id FROM Customers WHERE FirstName='Tom'),
    '2017-07-11',  
    2, 
    (SELECT Price FROM Products WHERE ProductName='Galaxy S9')
),
( 
    (SELECT Id FROM Products WHERE ProductName='iPhone 8'), 
    (SELECT Id FROM Customers WHERE FirstName='Tom'),
    '2017-07-13',  
    1, 
    (SELECT Price FROM Products WHERE ProductName='iPhone 8')
),
( 
    (SELECT Id FROM Products WHERE ProductName='iPhone 8'), 
    (SELECT Id FROM Customers WHERE FirstName='Bob'),
    '2017-07-11',  
    1, 
    (SELECT Price FROM Products WHERE ProductName='iPhone 8')
);

-- Вложенные запросы также очень полезны в условиях выборок

-- Товары цена на которые выше средней
SELECT *
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

-- Коррелирующие подзапросы - подзапросы результаты которых зависят от строк,
-- которые извлекаются в основном запросе.











