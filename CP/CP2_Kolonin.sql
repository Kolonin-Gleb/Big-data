/*
1)Таблицы OE.CUSTOMERS.
Сформируйте новое поле GENDER_GROUP, при условии, 
если гендер мужского пола - значение 1,
если женского - значение 0.
*/

-- Формирование нового поля => Необходим CASE

SELECT
    CASE
        WHEN GENDER = 'M'
        THEN '1'
        ELSE '0'
        END AS GENDER_GROUP,
        GENDER
FROM oe.customers;

/*
2) Таблицы  OLYM.OLYM_MEDALS и OLYM.OLYM_GAMES
-- Нужно будет брать данные из 2х таблиц

Посчитать количество (золотых, серебряных, бронзовых) медалей,

-- Подсчёт => count(*)
-- Нужно считать разные виды медалей => GROUP BY MEDAL

полученные в Сиднее (2000 год)
-- Есть условие на год => WHERE

-- НУЖНО ИСПОЛЬЗОВАТЬ ВЛОЖЕННЫЙ ЗАПРОС, т.к. ID игры в Sydney в 2000 году. (Будет = 24)
-- И этот ID Нужно будет использовать для подсчёта в медалей в OLYM_MEDALS
-- по условию EVENT_ID = ID (= 24)
*/


SELECT
    count(*),
    med.MEDAL
FROM
OLYM.OLYM_MEDALS med,
OLYM.OLYM_GAMES games
WHERE (
med.EVENT_ID = (SELECT games.ID
    FROM OLYM.OLYM_GAMES games
    WHERE games.YEAR = 2000)
)
GROUP BY med.MEDAL;


SELECT * FROM OLYM.OLYM_MEDALS; -- Здесь есть инфа о медалях
SELECT * FROM OLYM.OLYM_GAMES; -- Здесь есть года игр

-- Получение ID игры в Sydney в 2000 году. (Будет = 24)
-- SELECT games.ID
-- FROM OLYM.OLYM_GAMES games
-- WHERE games.YEAR = 2000

№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№ ПОЧЕМУ ТАКОЕ РЕШЕНИЕ НЕРАБОТАЕТ?
/*
3)Таблицы OE.CUSTOMERS OE.ORDERS HR.EMPLOYEES
-- Нужно исп. 3 таблицы

Выведите имена покупателей и продавцов, 
-- OE.CUSTOMERS.CUST_FIRST_NAME - имя покупателя
-- HR.EMPLOYEES.FIRST_NAME - имя продовца

которые сделали заказ, ||| Это условие для выборки выше
-- OE.ORDERS.CUSTOMER_ID - ID заказчика и OE.ORDERS.SALES_REP_ID - ID продавца (они осущствляют заказ)

где у одного продавца сделал заказ минимум дважды один покупатель ||||||||| По другому нужно также вывести число заказов, что произошло между покупателем и продавцом
-- Нужно COUNT(*) для подсчёта числа заказов
-- Нужно GROUP BY чтобы считать для каждого покупателя отдельно
-- Нужно HAVING чтобы выводить инфу, только если заказов >= 2
-- 
*/

-- Может нужен вложенный запрос для чего-то?

SELECT
    cus.CUST_FIRST_NAME as покупатель,
    emp.FIRST_NAME as продавец
    count(ord.ORDER_ID) as число_сделок
FROM OE.CUSTOMERS cus, HR.EMPLOYEES emp, OE.ORDERS ord
WHERE cus.CUSTOMER_ID = ord.CUSTOMER_ID AND emp.EMPLOYEE_ID = ord.SALES_REP_ID
GROUP BY cus.CUST_FIRST_NAME, emp.FIRST_NAME
HAVING count(ord.ORDER_ID) >= 2 


-- cus.CUSTOMER_ID = ord.CUSTOMER_ID AND emp.EMPLOYEE_ID = ord.SALES_REP_ID -- Обнаружение заказа между выводимым покупателем и продавцом


SELECT * FROM OE.CUSTOMERS; -- Покупатели (CUST_FIRST_NAME - имя)
SELECT * FROM HR.EMPLOYEES; -- Продавцы (FIRST_NAME - имя)
SELECT * FROM OE.ORDERS; -- Заказы (CUSTOMER_ID, ORDER_ID) SALES_REP_ID = HR.EMPLOYEES.EMPLOYEE_ID - это и есть инфа о продовцах


