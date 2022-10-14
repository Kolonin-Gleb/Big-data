from select import select
import sqlite3
from numpy import insert
import pandas as pd

con = sqlite3.connect('database.db')
cursor = con.cursor()

# Загрузка df из csv файла в таблицу.
# Если таблица не пуста, она будет перезаписана
def csv2sql(filePath,tableName):
    df = pd.read_csv(filePath)
    df.to_sql(tableName, con, if_exists= 'replace', index= False)

def showTable(tableName):
    print('_'*10+tableName+'_'*10)
    cursor.execute(f'select * from {tableName}')
    for row in cursor.fetchall():
        print(row)

# Создание исторической таблицы и её представления
def init():
    cursor.execute('''
        create table if not exists auto_hist(
            id integer primary key autoincrement,
            model varchar(128),
            transmission varchar(128),
            body_type varchar(128),
            drive_type varchar(128),
            color varchar(128),
            production_year integer,
            auto_key integer,
            engine_capacity real,
            horsepower integer,
            engine_type varchar(128),
            price integer,
            milage integer,
            deleted_flg integer default 0,
            start_dttm datetime default current_timestamp,
            end_dttm datetime default (datetime('2999-12-31 23:59:59'))
        )
    ''')

    cursor.execute('''
        create view if not exists v_auto as
        select 
            id
            ,model
            ,transmission
            ,body_type
            ,drive_type
            ,color
            ,production_year
            ,auto_key
            ,engine_capacity
            ,horsepower
            ,engine_type
            ,price
            ,milage
        from auto_hist
        where current_timestamp between start_dttm and end_dttm
    ''')

# Временная таблица для хранения новой инфы
def createTableNewRows():
    cursor.execute('''
        create table auto_01 as
            select
                t1.*
            from t_auto t1
            left join v_auto t2
            on t1.auto_key = t2.auto_key
            where t2.auto_key is null
    ''')

# Временная таблица для хранения удалённых записей
def createTableDeleteRows():
    cursor.execute('''
        create table auto_02 as
            select
                t1.*
            from v_auto t1
            left join t_auto t2
            on t1.auto_key = t2.auto_key
            where t2.auto_key is null
    ''')

# Временная таблица для хранения изменненных записей
def createTableChangeRows():
    cursor.execute(''' 
        create table auto_03 as
            select
            t1.*
            from t_auto t1
            inner join v_auto t2
            on t1.auto_key = t2.auto_key
            and (
                1 = 0
                or t1.model  <> t2.model
                or t1.transmission  <> t2.transmission
                or t1.body_type  <> t2.body_type
                or t1.drive_type  <> t2.drive_type
                or t1.color  <> t2.color
                or t1.production_year  <> t2.production_year
                or t1.engine_capacity  <> t2.engine_capacity
                or t1.horsepower  <> t2.horsepower
                or t1.engine_type  <> t2.engine_type
                or t1.price  <> t2.price
                or t1.milage  <> t2.milage
            )
    ''')

# Обновление исторической таблицы из записей временных
def updateAutoHist():
    # ----------------------------- Первый этап - таблица auto_01
    # INSERT для новых объявлений
    cursor.execute('''
        insert into auto_hist(
            model
            ,transmission
            ,body_type
            ,drive_type
            ,color
            ,production_year
            ,auto_key
            ,engine_capacity
            ,horsepower
            ,engine_type
            ,price
            ,milage
        ) select
            model
            ,transmission
            ,body_type
            ,drive_type
            ,color
            ,production_year
            ,auto_key
            ,engine_capacity
            ,horsepower
            ,engine_type
            ,price
            ,milage
        from auto_01
    ''')

    # ----------------------------- Второй этап - таблица auto_03
    # UPDATE для измененных данных
    cursor.execute('''
        UPDATE auto_hist
        set end_dttm = datetime('now', '-1 second')
        where auto_key in (select auto_key from auto_03)
        and end_dttm = datetime('2999-12-31 23:59:59')
    ''')

    # INSERT для измененных объявлений
    cursor.execute('''
        insert into auto_hist(
            model
            ,transmission
            ,body_type
            ,drive_type
            ,color
            ,production_year
            ,auto_key
            ,engine_capacity
            ,horsepower
            ,engine_type
            ,price
            ,milage
        ) select
            model
            ,transmission
            ,body_type
            ,drive_type
            ,color
            ,production_year
            ,auto_key
            ,engine_capacity
            ,horsepower
            ,engine_type
            ,price
            ,milage
        from auto_03
    ''')
    # ----------------------------- Третий этап - таблица auto_02
    # UPDATE для удаленных объявлений
    cursor.execute('''
        UPDATE auto_hist
        set end_dttm = datetime('now', '-1 second')
        where auto_key in (select auto_key from auto_02)
        and end_dttm = datetime('2999-12-31 23:59:59')
    ''')

    # INSERT для удаленных объявлений
    cursor.execute('''
        insert into auto_hist(
            model
            ,transmission
            ,body_type
            ,drive_type
            ,color
            ,production_year
            ,auto_key
            ,engine_capacity
            ,horsepower
            ,engine_type
            ,price
            ,milage
            ,deleted_flg
        ) select
            model
            ,transmission
            ,body_type
            ,drive_type
            ,color
            ,production_year
            ,auto_key
            ,engine_capacity
            ,horsepower
            ,engine_type
            ,price
            ,milage
            ,1
        from auto_02
    ''')

    con.commit()

# Очистка содержимого временных таблиц
def deleteTMPtables():
    cursor.execute('drop table if exists t_auto')
    cursor.execute('drop table if exists auto_01')
    cursor.execute('drop table if exists auto_02')
    cursor.execute('drop table if exists auto_03')

deleteTMPtables()
init()
csv2sql('data.csv', 't_auto')
createTableNewRows()
createTableDeleteRows()
createTableChangeRows()
updateAutoHist()

showTable('t_auto')
showTable('auto_01')
showTable('auto_02')
showTable('auto_03')

showTable('auto_hist')

