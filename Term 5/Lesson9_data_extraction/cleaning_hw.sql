-- Создание и заполнение таблицы gleb_log очищенными данными из таблицы de.log

-- CREATE TABLE p3.gleb_log as
-- 	SELECT
-- 		substr(data, 1, strpos(data, chr(9))-1) as ip,
-- 		to_timestamp(substr(data, strpos(data, chr(9))+3, 14), 'YYYYMMDDHH24MISS') as dt,
-- 		concat(split_part(data, chr(9), 5), split_part(data, chr(9), 6), split_part(data, chr(9), 7)) as link,
-- 		substr(split_part(data, chr(9), 8), 1, strpos(split_part(data, chr(9), 8), '/')-1) as browser,
-- 		substr(split_part(data, chr(9), 8), strpos(split_part(data, chr(9), 8), '/')+1) as user_agent
-- 	from de.log

-- NOTES:

-- Получение всех ip адресов
with report as
(
	select
		substr(data, 1, strpos(data, chr(9))-1) as ip,
		substr(data, strpos(data, chr(9))+1) as region
	from de.ip
)
with logs as
(
	select
		substr(data, 1, strpos(data, chr(9))-1) as ip,
		to_timestamp(substr(data, strpos(data, chr(9))+3, 14), 'YYYYMMDDHH24MISS') as dt,
		concat(split_part(data, chr(9), 5), split_part(data, chr(9), 6), split_part(data, chr(9), 7)) as link,
		substr(split_part(data, chr(9), 8), 1, strpos(split_part(data, chr(9), 8), '/')-1) as browser,
		substr(split_part(data, chr(9), 8), strpos(split_part(data, chr(9), 8), '/')+1) as user_agent
	from de.log
)

SELECT * FROM logs
INNER JOIN logs.ip = report.ip

-- Замена ip адресов на названия регионов



-- SELECT
-- 	substr(data, 1, strpos(data, chr(9))-1) as ip,
-- 	to_timestamp(substr(data, strpos(data, chr(9))+3, 14), 'YYYYMMDDHH24MISS') as dt,
-- 	concat(split_part(data, chr(9), 5), split_part(data, chr(9), 6), split_part(data, chr(9), 7)) as link,
-- 	substr(split_part(data, chr(9), 8), 1, strpos(split_part(data, chr(9), 8), '/')-1) as browser,
-- 	substr(split_part(data, chr(9), 8), strpos(split_part(data, chr(9), 8), '/')+1) as user_agent
-- from de.log

-- Создание и заполнение таблицы gleb_report очищенными данными из таблицы de.ip
-- CREATE TABLE p3.gleb_report as
-- SELECT
-- 	COUNT(ip) as popularity,
-- 	region
-- 	FROM (select
-- 		substr(data, 1, strpos(data, chr(9))-1) as ip,
-- 		substr(data, strpos(data, chr(9))+1) as region
-- 		from de.ip) as s1
-- GROUP BY region
-- ORDER BY popularity

-- NOTES

-- with report as
-- (
-- 	select
-- 		substr(data, 1, strpos(data, chr(9))-1) as ip,
-- 		substr(data, strpos(data, chr(9))+1) as region
-- 	from de.ip
-- )

-- CREATE TABLE p3.gleb_report as
-- 	select
-- 		substr(data, 1, strpos(data, chr(9))-1) as ip,
-- 		substr(data, strpos(data, chr(9))+1) as region
-- 	from de.ip