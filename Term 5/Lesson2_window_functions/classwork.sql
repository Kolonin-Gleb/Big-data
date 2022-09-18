select * from employees;


SELECT 
	first_name,
	last_name,
	max(salary) over(PARTITION BY department_id) - salary as delta
FROM employees;

-- Оконная функция - over
-- У оконных функций есть параметры, к примеру:
-- PARTITION BY
-- 


-- Сформируйте сколько должен денег каждый департамент id в дни зачисления на работу сотрудника

-- Как растут расходы департаментов по мере найма новых сотрудников
-- partition by - группировка по department_id
-- order by - сортировка по времени найма

-- rows between - задаёт строки, что будут участвовать в вычислениях 
-- 1 PERCEDING and 1 FOLLOWING - ограничение окна оконной функции.
-- То, сколько строк будут участвовать в вычислениях функции (sum)
-- В этом случае суммируется 1 предыдущая строка, текущая и 1 последующая
SELECT
	first_name,
	last_name,
	department_id,
	hire_date,
	sum(salary) over(PARTITION BY department_id order by hire_date rows between 1 PRECEDING and 1 FOLLOWING)
from employees;


-- Дополнительные параметры PARTITION BY

-- n PERCENDING указывается в начале диапозона (n + число предыдущих строк)
-- n FOLLOWING указывается в конце диапозона (n - число предыдущих строк)
-- CURRENT ROW - указывается и слева и справа (без аргументов). 


SELECT
	first_name,
	last_name,
	department_id,
	hire_date,
	sum(salary) over(PARTITION BY department_id order by hire_date rows between current row PRECEDING and 1 FOLLOWING)
from employees;


-- Оконные функции использующие в вычислениях соседние поля
-- lag - значение с предыдущей строки
-- lead - значение с следующей строки
-- через , можно добавить шаг и default значение

SELECT
	lag(salary, 2, 0) over(order by salary),
	salary,
	lead(salary, 2, 0) over(order by salary)
FROM employees;


-- row number - простая нумерация строк
-- rank - нумерует уникальные строки
-- rank для своей работы неявно сортирует данные
-- для нумерации использует id, поэтому возможны пробелы в нумерации
-- dense rank 
-- для нумерации использует собсвенный шаг = 1

SELECT
	row_number() over(order by salary),
	rank() over(order by salary),
	dense_rank() over(order by salary),
	salary
FROM employees;


-- Задача 
-- dense_rank

-- Определите id департаментов, которые занимают третье место (в списке по убыванию) по кол-ву сотрудников.

-- 1) Посчитать число сотрудников в департаментах
-- 2) Отсортировать по убыванию
-- 3) добавить условие WHERE


SELECT
    t2.department_id
from (
    select
        t1.department_id,
        dense_rank() over(order by t1.cnt desc) as rank,
        t1.cnt
    from (
        SELECT
            count(*) as cnt,
            department_id
        from employees
        group by department_id
        ) as t1
    ) as t2
where t2.rank = 3








