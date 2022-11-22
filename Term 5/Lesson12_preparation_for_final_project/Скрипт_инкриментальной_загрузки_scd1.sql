-- Обозначения 
-- stg = staging слой = слой временного хранения данных. Хранит данные в исходном виде.
-- dt / target слой = слой на котором формируются исторические таблицы и производится чистка данных
-- report = слой отчёт


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

-- Нужна для определения записей, что есть в target, но отсутствуют в source
create table p3.XXXX_stg_del(
    id integer
);

create table p3.XXXX_target(
    id integer,
    val varchar(50),
    create_dt timestamp(0),
    update_dt timestamp(0)
);

-- Эта таблица служит для оптимизации при добавлении данных в хранилище.
-- Оптимизация происходит за счёт того, что в ней хранятся
-- названия таблиц, данные в которых были изменены
-- Эти данные подтягиваются при заполнении stg слоя. 
-- Добавляются только записи, дата обновления которых > 
-- даты последнего измения таблицы (из meta таблицы)

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

-- ------------------------
-- Начало процесса
-- Захват данных

-- Очистка stage-слоя
delete from p3.XXXX_stg;
delete from p3.XXXX_stg_del;



-- захват данных из источника в stage-слой (кроме удалённых записей) (оптимизировали) 
insert into p3.XXXX_stg (id, val, update_dt) 
    select 
        id,
        val,
        update_dt
    from p3.XXXX_source
    where update_dt > (select max_update_dt from p3.XXXX_meta where schema_name = 'p3' and table_name = 'XXXX_source')
-- добавляем только те записи, которые являются новымми для таблицы meta.


-- Захват ключей для удалённых записей.
insert into p3.XXXX_stg_del (id)
select id from p3.


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
-- Можно описать этот процесс используя merge
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

-- Фиксация транзакции
commit;

