-- Создание очищенных таблиц исходных данных

-- CREATE TABLE p3.gleb_ip_cleaned AS 
-- (
-- 	select
-- 		substr(data, 1, strpos(data, chr(9))-1) as ip,
-- 		substr(data, strpos(data, chr(9))+1) as region
-- 	from de.ip
-- )
-- SELECT * FROM p3.gleb_ip_cleaned;

---- CREATE TABLE p3.gleb_unique_ip_cleaned AS
---- (
---- 	SELECT UNIQUE(ip), region from p3.gleb_ip_cleaned
---- )

-- CREATE TABLE p3.gleb_log_cleaned AS
-- (
-- 	select
-- 		substr(data, 1, strpos(data, chr(9))-1) as ip,
-- 		to_timestamp(substr(data, strpos(data, chr(9))+3, 14), 'YYYYMMDDHH24MISS') as dt,
-- 		concat(split_part(data, chr(9), 5), split_part(data, chr(9), 6), split_part(data, chr(9), 7)) as link,
-- 		substr(split_part(data, chr(9), 8), 1, strpos(split_part(data, chr(9), 8), '/')-1) as browser,
-- 		substr(split_part(data, chr(9), 8), strpos(split_part(data, chr(9), 8), '/')+1) as user_agent
-- 	from de.log
-- )
SELECT * FROM p3.gleb_log_cleaned;

-- Формирование итоговой таблицы GLEB_log
-- CREATE OR REPLACE TABLE p3.gleb_log AS
-- (
-- 	SELECT * FROM gleb_log_cleaned
-- 	INNER JOIN gleb_log_cleaned.ip = gleb_ip_cleaned.ip
-- )

CREATE TABLE p3.gleb_log AS
(
	SELECT
		gleb_ip_cleaned.region,
		logs.dt,
		logs.link,
		logs.browser,
		logs.user_agent
	FROM p3.gleb_log_cleaned as logs
	INNER JOIN p3.gleb_ip_cleaned ON logs.ip = p3.gleb_ip_cleaned.ip
)



