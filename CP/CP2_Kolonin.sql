/*
1)Таблицы OE.CUSTOMERS.
Сформируйте новое поле GENDER_GROUP, при условии, 
если гендер мужского пола - значение 1,
если женского - значение 0.
*/

/*
-- Формирование нового поля => Необходим CASE

SELECT
    CASE
        WHEN GENDER = 'M'
        THEN '1'
        ELSE '0'
        END AS GENDER_GROUP,
        GENDER
FROM oe.customers;

*/

-- Без вспомогательной информации

SELECT
    CASE
        WHEN GENDER = 'M'
        THEN '1'
        ELSE '0'
        END AS GENDER_GROUP
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

/*
3) Решен в отдельном файле
*/









