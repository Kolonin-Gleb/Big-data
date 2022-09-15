-- Сформируйте поле delta которое содержит разницу
-- между максимальной зарплатой в отделе и зарплатой сотрудника.


-- Решение

-- Подзапрос, что будет использоваться позже
-- SELECT
-- 	department_id,
-- 	max(salary) as max_salary
-- from employees
-- GROUP BY department_id;

-- Итог
-- SELECT
-- 	t1.first_name,
-- 	t1.last_name,
-- 	t1.salary,
-- 	t2.max_salary - t1.salary as delta
-- from employees as t1
-- inner join (
-- 	SELECT
-- 		department_id,
-- 		max(salary) as max_salary
-- 	from employees
-- 	GROUP BY department_id
-- ) as t2 on t1.department_id = t2.department_id

-- Решение с оконной функцией


