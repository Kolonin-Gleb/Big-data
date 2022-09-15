-- Составные типы данных


-- Столбцы в таблице в PostgreSQL могут представлять массивы других типов данных

CREATE TABLE posts(
	id serial primary key,
	title VARCHAR(30),
	body text,
	tags VARCHAR(10)[]
);

-- Для определения массива после типа данных ставятся []

INSERT INTO posts(title, body, tags) VALUES
('Post title', 'Post text', '{"sql", "postgres", "database", "plsql"}');
-- Массив определяется в '', как и строка.
-- Элементы массива пишутся внутри {}

select * from posts;


select tags from posts;

-- Используя срезы можно забрать часть значения из массива
-- В качестве стартового индекса можно указать значение <= 1. Оно всё равно будет считаться 1ым элементом.
-- Таким образом нумерация эл. в массиве Postgre начинается с 1.
select tags[1:3] from posts;
-- И начальный и конечный индексы - включаются

select tags[10:50] from posts;
-- Вызвать ошибку неверно указав индексы для среза не получится


-- Изменение массива

-- Удаление содержимого
update posts
set tags='{}'
where id = 1;

-- Перезапись
update posts
set tags='{"sql", "postgres", "database"}'
where id = 1;

-- Изменение по индексу
update posts
set tags[1] = 'system2'
where id = 1;


select * from posts;

