-- [10:50 AM] Мовсисян Тигран Варужанович
-- У нас есть таблица проводок по счетам и мы хотим получить баланс после совершения каждой проводки.


create table tBalance( 
    id number, 
    account varchar2(20), 
    value number 
);
insert into tBalance values (1,'01',100); 
insert into tBalance values (2,'01',200); 
insert into tBalance values (3,'01',-100); 
insert into tBalance values (4,'01',200); 
insert into tBalance values (5,'01',100); 
insert into tBalance values (6,'01',-100); 
insert into tBalance values (7,'01',100); 
insert into tBalance values (8, '02',10); 
insert into tBalance values (9, '02',20); 
insert into tBalance values (10,'02',-10); 
insert into tBalance values (11,'02',-20); 
insert into tBalance values (12,'02',10); 
insert into tBalance values (13,'02',-10); 
insert into tBalance values (14,'02',10);

SELECT * FROM tBalance;

-- Формируем аттрибут итоговой суммы счетов клиентов
-- over(partition by ...) - позволяет посчитать 
-- order by позволяет увидеть баланс после каждой операции.
SELECT
    id,
    account,
    value,
    sum(value) over(partition by ACCOUNT order by id) as cur_balance
FROM tBalance;

-- Функции, что могут быть использованы только в оконных функциях
-- row_number() - для нумерации строк (дубли имеют разные номера)
-- rank() - Нумерует строки по уникальности их позициями (дубли имеют одинаковый номер. Новый эл = номеру его строки)
-- dense_rank() - нумерует строки по уникальности (дубли имеют одинаковый номер)

-- row_number() - yevthetn dct cnhjrb
SELECT
    row_number() over(order by(job_id)) as row_num,
    job_id,
    dense_rank() over(order by job_id) as dense_ran,
    job_id,
    rank() over(order by job_id) as ran
FROM hr.employees;



-- Определите id департамента, который стоит на втором месте (в списке по убыванию) по кол-ву сотрудников.
-- Считаю число сотрудников в каждом департаменте

-- Использую подзапрос
-- Число сотрудников лучше посчитать обычной группировкой и агрегацией, а не оконной функции
-- 

SELECT * FROM HR.employees WHERE department_id = 40;

SELECT
    count(employee_id) as count_of_emp,
    department_id
FROM HR.employees
group by department_id
order by count_of_emp DESC;


-- Правильное решение

-- Подсчёт кол. сотрудников. Будет вложенным запросом
-- Т.к. сразу нельзя сделать WHERE row_id = 2; Помещаем в ещё 1 вложенный запрос
SELECT
    department_id
FROM(
    SELECT
        department_id,
        cnt,
        row_number() over(order by cnt DESC) as row_id
    from (
        SELECT
            count(*) as cnt,
            department_id
        from hr.employees
        GROUP by department_id
        )
    )
WHERE row_id = 2;



-- Определите id департаментов, которые занимают 3 место по кол. сотрудников

SELECT
    department_id
FROM(
    SELECT
        department_id,
        cnt,
        dense_rank() over(order by cnt DESC) as dep_rank
    from (
        SELECT
            count(*) as cnt,
            department_id
        from hr.employees
        GROUP by department_id
        )
    )
WHERE dep_rank = 3;

-- Доп. функции
-- Для использования в вычислениях соседних строк
-- lag - Значение со строки выше текущей
-- lead - Значение со строки ниже текущей
-- 2 Параметром можно передавать через сколько строк брать данные
-- 3 параметром можно задать значения для тех строк, когда не удалось определить значение в предшествующей / последующей строке

SELECT
    lag(salary, 2, -1) over(order by salary) as lag,
    salary,
    lead(salary, 2, -1) over(order by salary) as lead
FROM HR.employees;

-- ДЗ: Определить разницу зарплаты сотрудника по отношению к зарплате предыдущего и последующего сотрудника по размеру зарплаты.


