drop table p3.merge_bonuses;
create table p3.merge_bonuses (
    employee_id numeric,
    bonus numeric,
    primary key (employee_id),
    constraint check_bonus check (bonus between 0 and 1000) 
);
insert into p3.merge_bonuses (employee_id)
    select
        employee_id
    from hr.employees
    where (department_id = 30 or department_id = 80) and salary > 12000;
select * from p3.merge_bonuses;
insert into p3.merge_bonuses (employee_id, bonus) values (147, 100)
--on conflict on constraint unique_empl                 конфликт по индексу
--on conflict (employee_id)                             конфликт по атрибуту (PK)
do update  
    set employee_id = 151;
-- (временно closed)
-- merge into p3.merge_bonuses t1
--  using (
--      select
--          employee_id,
--          salary,
--          department_id
--      from hr.employees
--      where department_id = 80
--  ) t2
--  on t1.employee_id = t2.employee_id
--  when matched then 
--      update set t1.bonus = t1.bonus + t2.salary * 0.1
--  when not matched then
--      insert (t1.emoloyee_id, t1.bonus) values (t2.employee_id, t2.salary*0.01);