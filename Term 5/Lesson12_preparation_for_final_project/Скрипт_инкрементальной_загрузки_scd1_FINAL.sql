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

create table p3.XXXX_stg_del(
    id integer
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

insert into p3.XXXX_source (id, val, update_dt) values (5, 'L', now());

update p3.XXXX_source set val = 'Y', update_dt = now() where id = 2;
update p3.XXXX_source set val = 'X', update_dt = now() where id = 3

delete from p3.XXXX_source where id = 1;

select * from p3.XXXX_source;
select * from p3.XXXX_stg;
select * from p3.XXXX_target;
select * from p3.XXXX_meta;

delete from p3.XXXX_target;
delete from p3.XXXX_source;

insert into p3.XXXX_meta (schema_name, table_name, max_update_dt) 
values ('p3', 'XXXX_source', to_timestamp('1900-01-01', 'YYYY-MM-DD'));

-- ---------------------------------------------
--  (начало процесса )
-- 1 этап
-- Захват данных
-- Очистка stage-слоя

delete from p3.XXXX_stg;
delete from p3.XXXX_stg_del;


-- 2 этап
-- захват данных из источника в stage-слой (оптимизировали) (кроме удалений)
insert into p3.XXXX_stg (id, val, update_dt) 
    select 
        id,
        val,
        update_dt
    from p3.XXXX_source
    where update_dt > (select max_update_dt from p3.XXXX_meta where schema_name = 'p3' and table_name = 'XXXX_source');
 
-- 3 этап   
-- Захват ключей для вычисления удаленных записей
insert into p3.XXXX_stg_del (id)
select id from p3.XXXX_source;
    

-- 4 этап
-- Запись данных в детальный слой
-- insert into p3.XXXX_target (id, val, create_dt, update_dt)
-- select
--     t1.id,
--     t1.val,
--     t1.update_dt,
--     null
-- from p3.XXXX_stg t1
-- left join p3.XXXX_target t2
-- on t1.id = t2.id
-- where t2.id is null;

-- -- 5 этап
-- -- Обновление данных в детальном слое
-- update p3.XXXX_target 
-- set
--     val = upd.val,
--     update_dt = upd.update_dt
-- from (
--     select
--         t1.id,
--         t1.val,
--         t1.update_dt,
--         null
--     from p3.XXXX_stg t1
--     inner join p3.XXXX_target t2
--     on t1.id = t2.id
--     where 
--         t1.val <> t2.val or (t1.val is null and t2.val is not null) or (t1.val is not null and t2.val is null)
-- ) upd
-- where XXXX_target.id = upd.id

-- Замена 4 и 5 этапа!
-- Попытка сделать merge вместо 4 и 5 этапа (4 и 5 этап необходимо пропустить)
merge into p3.XXXX_target tgt
using (
	select
        t1.id,
        t1.val,
        t1.update_dt
    from p3.XXXX_stg t1
    left join p3.XXXX_target t2
    on t1.id = t2.id
    where 
        t2.id is null or 
        (t2.id is not null and ( 1=0 
        	or t1.val <> t2.val or (t1.val is null and t2.val is not null) or (t1.val is not null and t2.val is null)
        )
        )
) stg
on (tgt.id = stg.id)
when not matched then 
	insert (id, val, create_dt , update_dt) values (stg.id, stg.val, stg.update_dt, null)
when matched then 
	update set 
		val = stg.val,
		update_dt = stg.update_dt;



-- 6 этап
-- Удаленные записи:
delete from p3.XXXX_target 
where id in (
	select
		t1.id
	from p3.XXXX_target t1
	left join p3.XXXX_stg_del t2
	on t1.id = t2.id
	where t2.id is null
);


-- 7 этап
-- Обновление мета-данных
update p3.XXXX_meta
set max_update_dt = coalesce((select max(update_dt) from p3.XXXX_stg), (select max_update_dt from p3.XXXX_meta where schema_name = 'p3' and table_name = 'XXXX_source'))
where schema_name = 'p3' and table_name = 'XXXX_source'

-- 8 этап
-- Фиксация транзакции
commit;


-- TODO: Преобразовать скрипт для инкрементальной загрузки в scd2 формат
-- start_dttm  = effective_from
-- end_dttm    = effective_to
-- deleted_flg 