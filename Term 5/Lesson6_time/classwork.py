import sqlite3
import time
import pandas as pd

con = sqlite3.connect('database(scd2)2.db')
cursor = con.cursor()

def init_table():
    cursor.execute('''
        create table if not exists product_hist(
            id integer primary key autoincrement,
            name varchar(128),
            price integer,
            start_dttm datetime default current_timestamp,
            end_dttm datetime default (datetime('2999-12-31 23:59:59')),
            deleted_flg integer default 0
        )
    ''')

def addProduct(name, price):
    '''Обновление записи о имеющемся продукте или добавление нового'''

    # Делаем имеющуюся запись устаревшей
    # По name
    cursor.execute('''
        update product_hist
        set end_dttm = datetime('now', '-1 second')
        where name = ? and end_dttm = (datetime('2999-12-31 23:59:59'))
    ''',[name])

    # Добавление новой актуальной записи
    cursor.execute('''
        insert into product_hist (name, price) values (?,?)
    ''',[name, price])
    con.commit()

def removeProduct(name):
    '''Логическое удаление неактуальной строки.
    Актуальная строка не будет логически удалена.'''

    # Получение неактуальной строки по имени.
    cursor.execute('''
    select 
        name,
        price
    from product_hist 
    where name = ? and end_dttm = (datetime('2999-12-31 23:59:59'))
    ''',[name])
    row = cursor.fetchone()

    # Если неактуальная строка не найдена, то выход
    if row == None:
        return None # Неактуальная строка не найдена

    # Установка неактуальной записи времени её удаления
    cursor.execute('''
    update product_hist
    set end_dttm = datetime('now', '-1 second')
    where name = ? and end_dttm = (datetime('2999-12-31 23:59:59'))
    ''',[name])

    # Добавление записи о удалении неактуальной строки
    cursor.execute('''
    insert into product_hist (name, price, deleted_flg) values (?,?,1)
    ''', row)
    con.commit()

def showTable():
    cursor.execute('select * from product_hist')
    for row in cursor.fetchall():
        print(row)

def save_to_csv(table, end_date):
    result = f'select * from {table} WHERE DATE(end_dttm) == DATE({end_date})'
    df = pd.read_sql(result, con)
    df.to_csv('result.csv', index= False)

init_table()
addProduct('Shokolad', 100)
time.sleep(2)
addProduct('Shokolad', 150)
time.sleep(2)
addProduct('Twix', 400)
removeProduct('Shokolad')
showTable()

save_to_csv('product_hist')
