-- 1 Этап - создание всех таблиц

CREATE TABLE client
(
    id INT PRIMARY KEY,
    name VARCHAR(64),
    lastname VARCHAR(64),
    locator_id INT,
    city VARCHAR(64)
);

CREATE TABLE locators
(
    locator_id INT PRIMARY KEY,
    phone VARCHAR(20),
    email VARCHAR(64)
);

CREATE TABLE transactions
(
    id INT PRIMARY KEY,
    client_id INT,
    money_amount NUMBER(*, 2),
    currency_id INT
);

CREATE TABLE currency_types
(
    id INT PRIMARY KEY,
    title VARCHAR(16)
);

CREATE TABLE currency_exchange
(
    id INT,
    to_currency_id INT,
    coef NUMBER(*, 3)
);

-- 2 Этап - заполнение всех таблиц

INSERT INTO client (id, name, lastname, locator_id, city) VALUES (1, 'Александр', 'Иванов', 1, 'Уфа');
INSERT INTO client (id, name, lastname, locator_id, city) VALUES (2, 'Борис', 'Калинин', 7, 'Ереван');
INSERT INTO client (id, name, lastname, locator_id, city) VALUES (3, 'Петр', 'Суворов', 2, 'Казань');
INSERT INTO client (id, name, lastname, locator_id, city) VALUES (4, 'Юрий', 'Сахаров', 6, 'Владимир');
INSERT INTO client (id, name, lastname, locator_id, city) VALUES (5, 'Всеволод', 'Долгих', 4, 'Екатеринбург');
INSERT INTO client (id, name, lastname, locator_id, city) VALUES (6, 'Александр', 'Виноградов', 5, 'Москва');
INSERT INTO client (id, name, lastname, locator_id, city) VALUES (7, 'Николай', 'Николаев', 2, 'Нижний Новгород');
INSERT INTO client (id, name, lastname, locator_id, city) VALUES (8, 'Ольга', 'Печуркина', 1, 'Санкт-Петербург');
INSERT INTO client (id, name, lastname, locator_id, city) VALUES (9, 'Екатерина', 'Александрова', 8, 'Чебоксары');
INSERT INTO client (id, name, lastname, locator_id, city) VALUES (10, 'Юлия', 'Абрикосова', 3, 'Москва');

INSERT INTO locators (locator_id, phone, email) VALUES (1, '+7(495)563-83-79', 'ivan.92@mail.ru');
INSERT INTO locators (locator_id, phone, email) VALUES (2, '+374(905)750-44-13', 'Nik.nik@mail.ru');
INSERT INTO locators (locator_id, phone, email) VALUES (3, '+7(916)258-30-30', 'Apricot.Yla@mail.ru');
INSERT INTO locators (locator_id, phone, email) VALUES (4, '+7(909)546-77-76', 'Dolg.Seva@mail.ru');
INSERT INTO locators (locator_id, phone, email) VALUES (5, '+374(903)391-77-01', 'Vino.Sasha@mail.ru');
INSERT INTO locators (locator_id, phone, email) VALUES (6, '+7(495)620-04-40', 'Sacharov.Yuri_13@mail.ru');
INSERT INTO locators (locator_id, phone, email) VALUES (7, '+374(905)980-02-08', 'Bor.Kalin@mail.ru');
INSERT INTO locators (locator_id, phone, email) VALUES (8, '+7(916)444-22-04', 'Katusha.93@mail.ru');


INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (1, 4, 16600, 2);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (2, 5, 5, 2);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (3, 7, 15000, 2);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (4, 7, 14700, 3);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (5, 10, 50000, 2);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (6, 7, 11000, 1);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (7, 2, 10900, 3);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (8, 6, 15400, 3);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (9, 5, 10800, 1);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (10, 7, 15100, 2);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (11, 8, 7, 1);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (12, 5, 10400, 1);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (13, 5, 17700, 2);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (14, 8, 15600, 2);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (15, 3, 14600, 2);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (16, 6,  13900, 2);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (17, 4,  700000, 2);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (18, 8,  13100, 2);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (19, 6,  17000, 1);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (20, 10,  16700, 3);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (21, 3, 1000000, 3);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (22, 7, 17300, 1);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (23, 2, 15100, 2);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (24, 7, 18600, 3);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (25, 3, 4, 1);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (26, 2, 18900, 2);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (27, 5, 13900, 1);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (28, 5, 14800, 3);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (29, 5, 17100, 1);
INSERT INTO transactions (id, client_id, money_amount, currency_id) VALUES (30, 4, 16700, 3);

INSERT INTO currency_types (id, title) values (1, 'Рубль');
INSERT INTO currency_types (id, title) values (2, 'Доллар');
INSERT INTO currency_types (id, title) values (3, 'Евро');

INSERT INTO currency_exchange (id, to_currency_id, coef) values (1, 2, 0.013);
INSERT INTO currency_exchange (id, to_currency_id, coef) values (1, 3, 0.011);
INSERT INTO currency_exchange (id, to_currency_id, coef) values (2, 1, 76.01);
INSERT INTO currency_exchange (id, to_currency_id, coef) values (2, 3, 0.85);
INSERT INTO currency_exchange (id, to_currency_id, coef) values (3, 1, 89.88);
INSERT INTO currency_exchange (id, to_currency_id, coef) values (3, 2, 1.18);

-- 3 Этап - Выборки

SELECT name, lastname  FROM client WHERE city = 'Москва';

SELECT name FROM client WHERE name LIKE 'А%';

SELECT * FROM locators WHERE phone NOT LIKE '+7%';

SELECT * FROM transactions WHERE currency_id = 1 OR currency_id = 2;


SELECT * FROM transactions WHERE (currency_id = 1 AND money_amount < 10) OR (currency_id = 2 AND money_amount > 20000);

