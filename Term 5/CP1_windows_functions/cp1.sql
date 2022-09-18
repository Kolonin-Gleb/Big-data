-- CP1 Window functions


-- Задание 1 -- ГОТОВ!
-- Определите id департамента, который стоит на втором месте (в списке по убыванию) по кол-ву сотрудников.

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
where t2.rank = 2



-- Задача 2 -- ГОТОВ!
-- Определить разницу зарплаты сотрудника по отношению к зарплате предыдущего и последующего сотрудника по размеру зарплаты.
-- Результат должен сформировать два поля (lag_salary и lead_salary)

-- Сортироваться по возрастанию!!!
-- значение по умолчанию - null
SELECT 
	first_name,
	last_name,
	salary,
	salary - lag(salary) over(order by salary) as prev_salary_delta,
	lead(salary) over(order by salary) - salary as next_salary_delta
FROM employees;

-- Задача 3 -- ГОТОВ!
-- Необходимо рассчитать поле coef, хранящее среднее значение зарплаты, 
-- которое рассчитывается по значению текущего и двух последующих сотрудников таблицы employees

SELECT
	first_name,
	last_name,
	salary,
	avg(salary) over(rows between current row and 2 FOLLOWING) as coef
from employees;


-- Задание 4.

-- Шеф поручил важное задание по группировке сотрудников специальным строковым значением, которое вычисляется по следующему правилу:

-- Если процент зарплаты текущего сотрудника по отношению следующего будет меньше или равен 75 
-- - необходимо для атрибута group сформировать значение ‘junior’
-- Если процент будет меньше или равен 85 - сформировать значение ‘middle’
-- Если процент будет меньше или равне 95 - ‘senior’
-- В противном случае (больше 95 и NULL) сформировать значение - ‘lead’

-- ИДЕИ:
-- Здесь нужно использовать CASE 
-- Вложенные функции? 
-- 

SELECT 
	t1.first_name,
	t1.last_name,
	t1.salary,
	CASE 
      WHEN t1.next_salary_percentage <= 75  THEN 'junior'
      WHEN t1.next_salary_percentage <= 85  THEN 'middle'
	  WHEN t1.next_salary_percentage <= 95  THEN 'senior'
      ELSE 'lead'
	END groupka
FROM (
	SELECT
		first_name,
		last_name,
		salary,
		(salary * 100) / lead(salary) over(order by salary) as next_salary_percentage
	FROM employees ) as t1;


-- В выборке должен получится 1 junior и 1 middle
-- 107 строк
