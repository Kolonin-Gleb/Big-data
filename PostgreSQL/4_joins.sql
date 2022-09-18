-- Joins - Соединения данных
-- Соединять можно 2 и более таблиц одновременно

-- Неявное соединение таблиц

SELECT * FROM Orders, Customers
WHERE Orders.CustomerId = Customers.Id;

-- INNER JOIN
-- Показывает только те данные из таблиц, для которых нашлись пары

-- SELECT столбцы
-- FROM таблица1
--     [INNER] JOIN таблица2
--     ON условие1
--     [[INNER] JOIN таблица3
--     ON условие2]

SELECT * FROM customers, orders WHERE customers.id = orders.customerid;

-- Добавление информации о названии продукта к данным из Основной таблицы заказов
SELECT o.CreatedAt, o.ProductCount, p.productname
FROM orders as o
JOIN products as p ON p.id = o.productid;



-- OUTER JOIN - Общее название для всех Join-ов, кроме INNER, т.е.:
-- LEFT
-- RIGHT
-- FULL
-- LEFT/RIGHT JOIN 
-- Показывает все данные из левой/правой таблицы и их связи с данными правой/левой таблицы.
-- Данные левой таблицы, у которых не нашлось связи получат значение null
-- FULL JOIN 
-- Показывает все данные из обоих таблиц.
-- Если у данных нет пары, то они получают значение null


-- LEFT JOIN
-- Таблица customers - основная. Для неё находятся совпадения или ставится null
SELECT FirstName, CreatedAt, ProductCount, Price 
FROM Customers LEFT JOIN Orders 
ON Orders.CustomerId = Customers.Id;
-- Как видно Sam не делал заказов, поэтому у него null


-- CROSS JOIN 
-- Каждая строка из 1 таблицы соединяется с каждой строкой из другой таблицы
SELECT * FROM customers CROSS JOIN orders;


-- Группировка GROUP BY в соединениях
-- Пример с подсчётом количества заказов, что совершил каждый покупатель

SELECT FirstName, COUNT(Orders.id) as cnt
FROM CUSTOMERS INNER JOIN Orders
ON Orders.customerid = CUSTOMERS.id
GROUP BY CUSTOMERS.id
Order BY cnt DESC;


-- В чём же всё-таки отличие группировки от сортировки?
-- Группировка - объединение строк по одинаковому значению
-- Сортировка - объединение строк по возрастанию/убыванию

-- В этом примере группировка позволяет провести рассчёт кол. заказов совершенных каждым клиентом.
-- В то время как сортировка помогает с упорядочиванием вывода.


SELECT * FROM products;

SELECT * FROM orders;
-- Нелогичность этой таблицы в том, что price указывается для 1 экземпляра товара
-- "productid"	"customerid"	"createdat"	"productcount"	"price"
-- 		4			1			"2017-07-11"	2			56000
-- 		2			1			"2017-07-13"	1			51000
-- 		2			2			"2017-07-11"	1			51000
-- Купили 4 товар на 112.000
-- Купили 2 товар на 102.000. Его покупало 2 клиента

-- Вывод названий всех товаров и суммы, которую потратили на их покупку клиенты


-- Таблица товаров - основная. Все её записи должны войти в выборку

-- GROUP BY, чтобы вычислить общее число данного товара во всех заказах

-- Почему необходимо использование SUM?
-- SUM позволяет просуммировать затраты разных клиентов на этот товар.

-- В GROUP BY указываются поля
-- pr.id, pr.productname, pr.company, т.к. они выводятся в SELECT вместе с агрегационной функцией SUM

SELECT
pr.productname, pr.company,
SUM(ord.ProductCount * ord.price) as totalSum

FROM products as pr
LEFT JOIN orders as ord
ON ord.productid = pr.id
GROUP BY pr.id, pr.productname, pr.company;

-- Join позволяет объединить данные ГОРИЗОНТАЛЬНО, 
-- используя условие соединения

-- Объединение множеств - UNION
-- UNION - позволяет объединить два однотипных набора в один ВЕРТИКАЛЬНО.
-- Для UNION соединения типы данных должны быть совместимы


-- Создание данных для повторения

CREATE TABLE Bank_Customers
(
    Id SERIAL PRIMARY KEY,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    AccountSum NUMERIC DEFAULT 0
);
CREATE TABLE Employees
(
    Id SERIAL PRIMARY KEY,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL
);
  
INSERT INTO Bank_Customers(FirstName, LastName, AccountSum) VALUES
('Tom', 'Smith', 2000),
('Sam', 'Brown', 3000),
('Paul', 'Ins', 4200),
('Victor', 'Baya', 2800),
('Mark', 'Adams', 2500),
('Tim', 'Cook', 2800);

INSERT INTO Employees(FirstName, LastName) VALUES
('Homer', 'Simpson'),
('Tom', 'Smith'),
('Mark', 'Adams'),
('Nick', 'Svensson');

-- Выборка всех клиентов и сотрудников банка
-- Без ALL при наличии совпадения FirstName и LastName в клиентах и сотрудниках
-- данные будут выведены 1 раз
SELECT FirstName, LastName
FROM Bank_Customers
UNION ALL SELECT firstname, lastname FROM Employees;


-- Объединять выборки можно и из 1 таблицы.
-- Выдавая данные в зависимости от определенных условией.
-- Пример: В зависимости от суммы на счёте начислять определенные %

SELECT FirstName, LastName, AccountSum + AccountSum * 0.1 AS TotalSum
FROM Bank_Customers WHERE AccountSum < 3000
UNION SELECT FirstName, LastName, AccountSum + AccountSum * 0.3 AS TotalSum
FROM Bank_Customers WHERE AccountSum >= 3000;

