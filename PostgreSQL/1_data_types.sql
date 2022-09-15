CREATE TABLE users
(
	Id SERIAL PRIMARY KEY,
	Name CHARACTER VARYING(30),
	Age INTEGER
);

INSERT INTO users (Name, Age) VALUES ('Tom', 33);

SELECT * FROM users;


-- Типы данных в PostgreSQL

-- SERIAL - автоинкриментирующиеся числовое значение от 1 до ...

-- Имеются типы данных для денег, интернет-адресов, геометрии и т.д.



