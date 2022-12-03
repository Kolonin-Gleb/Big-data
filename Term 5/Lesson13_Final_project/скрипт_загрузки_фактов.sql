-- Данный из source загружаются из плоских файлов. 
--Подготовка осуществляется на стороне python
-- Пример данных: 

--phone,
--payments_source,
--sales_point,
--value,
--create_dt
--------------------------------------------------------------------
-- Инкрементальная загрузка фактов

-- 1. Очистка стейджингов.
delete from p3.tgrn_stg_payment_logs;


-- 2. Захват данных в стейджинг (кроме удалений).
insert into p3.tgrn_stg_payment_logs ( phone, payments_source, sales_point, value, create_dt )
select phone, payments_source, sales_point, value, create_dt from baratin.payment_logs
where create_dt > ( 
    select coalesce( last_update_dt, to_date( '1900-01-01', 'YYYY-MM-DD') ) 
    from p3.tgrn_meta where chema = 'p3' and table_name = 'PAYMENT_LOGS' );

-- 3. Делаем простую вставку изменений
insert into p3.tgrn_dwh_fct_payment_logs ( phone, payments_source, sales_point, value, create_dt )
select phone, payments_source, sales_point, value, create_dt from p3.tgrn_stg_payment_logs;

-- 4. Обновляем метаданные.
update p3.tgrn_meta
set last_update_dt = ( select max(create_dt) from p3.tgrn_stg_payment_logs )
where chema = 'P3' and table_name = 'PAYMENT_LOGS' and ( select max(create_dt) from p3.tgrn_stg_payment_logs ) is not null;

-- 5. Фиксируем транзакцию.
commit;