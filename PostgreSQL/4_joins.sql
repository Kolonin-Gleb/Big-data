-- Joins - Соединения данных

-- Неявное соединение таблиц

SELECT * FROM Orders, Customers
WHERE Orders.CustomerId = Customers.Id;

-- INNER JOIN

-- SELECT столбцы
-- FROM таблица1
--     [INNER] JOIN таблица2
--     ON условие1
--     [[INNER] JOIN таблица3
--     ON условие2]

-- Добавление информации о названии продукта к данным из таблицы заказов
SELECT o.CreatedAt, o.ProductCount, p.productname
FROM orders as o
JOIN products as p ON p.id = o.productid;













