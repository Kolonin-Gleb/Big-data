

select 'drop table p3.' || tablename from pg_catalog.pg_tables pt ;
select  'or t1.' || column_name  || '<> t2.' || column_name 
from information_schema.columns where table_schema = 'hr' and table_name = 'employees';

--Мета таблица
Когда какая таблица обновлялась

1 таблица
в ней 6 записей (для каждой таблицы)
4 ист. таблиц (cards, accounts, terminals, clients)
2 таблицы фактов (passport blacklist, transactions)

последнее обновление исторических таблиц. таблицы тер, карт, клиенты, паспорта.
