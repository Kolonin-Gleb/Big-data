drop table p3.bonuses;

create table p3.bonuses (
    employee_id numeric,
    bonus numeric default 100
);

insert into p3.bonuses (employee_id)
    select
        employee_id
    from hr.employees
    where (department_id = 30 or department_id = 80) and salary > 12000;
 select * from p3.bonuses;
 merge into p3.bonuses t1
  using (
      select
          employee_id,
          salary,
          department_id
      from hr.employees
      where department_id = 80 and salary > 11000
  ) t2
  on t1.employee_id = t2.employee_id
  when matched then 
      update set bonus = 500
  when not matched then
      insert (employee_id, bonus) values (t2.employee_id, 0);
	  
	  
	  