-- Задание: преобразовать срикпт инкрементальной загрузки в SCD2 формат.
--effective_from	
--effective_to	
--deleted_flg

--Подготовка данных

drop table XXXX_scd2_source;
create table p3.XXXX_scd2_source(
    id integer,
    val varchar(50),
    update_dt timestamp(0)
);

drop table XXXX_scd2_source;
create table p3.XXXX_scd2_stg(
    id integer,
    val varchar(50),
    update_dt timestamp(0)
);

drop table XXXX_scd2_source;
create table p3.XXXX_scd2_stg_del(
    id integer
);

drop table p3.XXXX_scd2_target;
create table p3.XXXX_scd2_target(
    id integer,
    val varchar(50),
    effective_from timestamp(0),
    effective_to timestamp(0) default to_timestamp('2999-12-31', 'YYYY-MM-DD'),
    deleted_flg char(1) default 'N'
);

drop table p3.XXXX_scd2_meta;
create table p3.XXXX_scd2_meta(
    schema_name varchar(30),
    table_name varchar(30),
    last_update_dt timestamp(0)
);

insert into p3.XXXX_scd2_source (id, val, update_dt) values (1, 'A', now());
insert into p3.XXXX_scd2_source (id, val, update_dt) values (2, 'B', now());
insert into p3.XXXX_scd2_source (id, val, update_dt) values (3, 'C', now());
insert into p3.XXXX_scd2_source (id, val, update_dt) values (4, 'P', now());

insert into p3.XXXX_scd2_source (id, val, update_dt) values (5, 'L', now());

update p3.XXXX_scd2_source set val = 'Y', update_dt = now() where id = 2;
update p3.XXXX_scd2_source set val = 'X', update_dt = now() where id = 3;

delete from p3.XXXX_scd2_source where id = 1;
delete from p3.XXXX_scd2_source where id = 4;

select * from p3.XXXX_scd2_source;
select * from p3.XXXX_scd2_stg;
select * from p3.XXXX_scd2_stg_del;
select * from p3.XXXX_scd2_target;
select * from p3.XXXX_scd2_meta;

delete from p3.XXXX_scd2_target;
delete from p3.XXXX_scd2_source;
delete from p3.XXXX_scd2_meta;

insert into p3.XXXX_scd2_meta (schema_name, table_name, last_update_dt) 
values ('p3', 'XXXX_scd2_source', to_timestamp('1900-01-01', 'YYYY-MM-DD'));

-- ---------------------------------------------
--  (начало процесса )
-- 1 этап
-- Захват данных
-- Очистка stage-слоя

delete from p3.XXXX_scd2_stg;
delete from p3.XXXX_scd2_stg_del;


-- 2 этап
-- захват данных из источника в stage-слой (оптимизировали) (кроме удалений)
insert into p3.XXXX_scd2_stg (id, val, update_dt) 
    select 
        id,
        val,
        update_dt
    from p3.XXXX_scd2_source
    where update_dt > (select last_update_dt from p3.XXXX_scd2_meta where schema_name = 'p3' and table_name = 'XXXX_scd2_source');
 
-- 3 этап   
-- Захват ключей для вычисления удаленных записей
insert into p3.XXXX_scd2_stg_del (id)
select id from p3.XXXX_scd2_source;
    

-- 4 этап
-- Запись данных в детальный слой
insert into p3.XXXX_scd2_target (id, val, effective_from)
select
    t1.id,
    t1.val,
    t1.update_dt
from p3.XXXX_scd2_stg t1
left join p3.XXXX_scd2_target t2
on t1.id = t2.id
where t2.id is null;

-- 5 этап
-- Обновление данных в детальном слое
update p3.XXXX_scd2_target 
set
    effective_to = upd.update_dt - interval '1 minute'
from (
    select
        t1.id,
        t1.val,
        t1.update_dt
    from p3.XXXX_scd2_stg t1
    inner join p3.XXXX_scd2_target t2
    on t1.id = t2.id
    where 
        t1.val <> t2.val or (t1.val is null and t2.val is not null) or (t1.val is not null and t2.val is null)
) upd
where XXXX_scd2_target.id = upd.id;

insert into p3.XXXX_scd2_target (id, val, effective_from)
select
        t1.id,
        t1.val,
        t1.update_dt
from p3.XXXX_scd2_stg t1
inner join p3.XXXX_scd2_target t2
on t1.id = t2.id
where 
  t1.val <> t2.val or (t1.val is null and t2.val is not null) or (t1.val is not null and t2.val is null);
 

-- 6 этап
-- Удаленные записи:
 
-- записываем удаленную запись 
insert into p3.XXXX_scd2_target (id, val, effective_from, deleted_flg)
select
	    t1.id,
	    t1.val,
	    now(),
	    'Y'
from p3.XXXX_scd2_target t1
left join p3.XXXX_scd2_stg_del t2
on t1.id = t2.id
where t1.effective_to = to_timestamp('2999-12-31', 'YYYY-MM-DD') and t2.id is null and t1.deleted_flg = 'N';

-- апдейтим старую запись (закрываем актуальность)
update p3.XXXX_scd2_target  tgt
set
	effective_to = now() - interval '1 minute'
where 
	1=1
	and effective_to = to_timestamp('2999-12-31', 'YYYY-MM-DD') 
	and deleted_flg = 'N'
	and id in (
			select
			    t1.id
			from p3.XXXX_scd2_target t1
			left join p3.XXXX_scd2_stg_del t2
			on t1.id = t2.id 
			where t2.id is null );

-- 7 этап
-- Обновление мета-данных
update p3.XXXX_scd2_meta
set last_update_dt = coalesce((select max(update_dt) from p3.XXXX_scd2_stg), (select last_update_dt from p3.XXXX_scd2_meta where schema_name = 'p3' and table_name = 'XXXX_source'))
where schema_name = 'p3' and table_name = 'XXXX_scd2_source';

-- 8 этап
-- Фиксация транзакции
commit;
