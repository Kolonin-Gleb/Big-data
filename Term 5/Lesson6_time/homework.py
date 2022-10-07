import sqlite3

import time # Для задержек
from datetime import datetime # Для выгрузки на указанную дату
import pandas as pd # Для формирования csv


con = sqlite3.connect('database(scd2)_users.db')
cursor = con.cursor()

def init_table():
    cursor.execute('''
        create table if not exists users_hist(
            id integer primary key autoincrement,
            name varchar(128),
            lastname varchar(128),
            age integer,
            salary float,
            start_dttm datetime default current_timestamp,
            end_dttm datetime default (datetime('2999-12-31 23:59:59')),
            deleted_flg integer default 0
        )
    ''')

def addUser(name, lastname, age, salary):
    '''Обновление записи о имеющемся пользователе или добавление его'''

    # Делаем имеющуюся запись о пользователе устаревшей
    # По name и lastname
    cursor.execute('''
        update users_hist
        set end_dttm = datetime('now', '-1 second')
        where name = ? and lastname = ? and end_dttm = (datetime('2999-12-31 23:59:59'))
    ''',[name, lastname])

    # Добавление актуальной записи о пользователе
    cursor.execute('''
        insert into users_hist (name, lastname, age, salary) values (?,?,?,?)
    ''',[name, lastname, age, salary])
    con.commit()

def removeUser(name, lastname):
    '''Логическое удаление неактуальной строки.
    Актуальная строку не будет логически удалена'''

    # Получение неактуальной строки по имени и фамилии
    cursor.execute('''
    select 
        name, lastname, age, salary
    from users_hist 
    where name = ? and lastname = ? and end_dttm = (datetime('2999-12-31 23:59:59'))
    ''',[name, lastname])

    # Если неактуальная строка не найдена, то выход
    row = cursor.fetchone()
    if row == None:
        return None # Неактуальная строка не найдена

    # Делаем имеющуюся запись устаревшей по имени и фамилии
    cursor.execute('''
    update users_hist
    set end_dttm = datetime('now', '-1 second')
    where name = ? and lastname = ? and end_dttm = (datetime('2999-12-31 23:59:59'))
    ''',[name, lastname])

    # Добавление записи о удалении неактуальной строки.
    # Используем row
    cursor.execute('''
    insert into users_hist (name, lastname, age, salary, deleted_flg) values (?,?,?,?,1)
    ''', row)
    con.commit()

def showTable():
    cursor.execute('select * from users_hist')
    for row in cursor.fetchall():
        print(row)

def save_to_csv(table, end_date):
    query = f'select * from {table} WHERE DATE({table}.end_dttm) = {end_date}'
    df = pd.read_sql(query, con)
    df.to_csv('result.csv', index= False)

init_table()
addUser('Gleb', 'Kolonin', 17, 4000.3)
time.sleep(2)
addUser('Max', 'Zdunov', 18, 50.99)
time.sleep(2)

print("--------------------------------------")
showTable()
print("--------------------------------------")

addUser('Gleb', 'Kolonin', 18, 8000.6) # Изменение записи. Проверить устаревание предудущей
removeUser('Max', 'Zdunov') # Логическое удаление пользователя

showTable()
print(datetime.today().date()) # Текущая дата
save_to_csv('users_hist', end_date=datetime.today().date())

