select 'drop table p3.' || tablename from pg_catalog.pg_tables pt ;
select  'or t1.' || column_name  || '<> t2.' || column_name 
from information_schema.columns where table_schema = 'hr' and table_name = 'employees';