--Подготовка данных
create table p3.XXXX_source(
    id integer,
    val varchar(50),
    update_dt timestamp(0)
);

create table p3.XXXX_stg(
    id integer,
    val varchar(50),
    update_dt timestamp(0)
);

create table p3.XXXX_target(
    id integer,
    val varchar(50),
    create_dt timestamp(0),
    update_dt timestamp(0)
);

create table p3.XXXX_meta(
    schema_name varchar(30),
    table_name varchar(30),
    max_update_dt timestamp(0)
);

insert into p3.XXXX_source (id, val, update_dt) values (1, 'A', now());
insert into p3.XXXX_source (id, val, update_dt) values (2, 'B', now());
insert into p3.XXXX_source (id, val, update_dt) values (3, 'C', now());
insert into p3.XXXX_source (id, val, update_dt) values (4, 'P', now());

update p3.XXXX_source set val = 'X', update_dt = now() where id = 3

select * from p3.XXXX_source;
select * from p3.XXXX_stg;
select * from p3.XXXX_target;
select * from p3.XXXX_meta;

delete from p3.XXXX_target;
delete from p3.XXXX_source;

insert into p3.XXXX_meta (schema_name, table_name, max_update_dt) 
values ('p3', 'XXXX_source', to_timestamp('1900-01-01', 'YYYY-MM-DD'));

-- -----------------
-- Захват данных

-- Очистка stage-слоя
delete from p3.XXXX_stg


-- запись данных из источника в stage-слой (оптимизировали)
insert into p3.XXXX_stg (id, val, update_dt) 
    select 
        id,
        val,
        update_dt
    from p3.XXXX_source;
    where update_dt > (select max_update_dt from p3.XXXX_meta where schema_name = 'p3' and table_name = 'XXXX_source')

-- Запись данных в детальный слой
insert into p3.XXXX_target (id, val, create_dt, update_dt)
select
    t1.id,
    t1.val,
    t1.update_dt,
    null
from p3.XXXX_stg t1
left join p3.XXXX_target t2
on t1.id = t2.id
where t2.id is null;

-- Обновление данных в детальном слое
update p3.XXXX_target 
set
    val = upd.val,
    update_dt = upd.update_dt
from (
    select
        t1.id,
        t1.val,
        t1.update_dt,
        null
    from p3.XXXX_stg t1
    inner join p3.XXXX_target t2
    on t1.id = t2.id
    where 
        t1.val <> t2.val or (t1.val is null and t2.val is not null) or (t1.val is not null and t2.val is null)
) upd
where XXXX_target.id = upd.id

-- Удаленные записи:
-- ----------------

-- Обновление мета-данных
update p3.XXXX_meta
set max_update_dt = coalesce((select max(update_dt) from p3.XXXX_stg), (select max_update_dt from p3.XXXX_meta where schema_name = 'p3' and table_name = 'XXXX_source'))
where schema_name = 'p3' and table_name = 'XXXX_source'
