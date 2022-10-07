import sqlite3
import pandas as pd
con = sqlite3.connect('database.db')
cursor = con.cursor()
def csv2sql(filePath,tableName):
    df = pd.read_csv(filePath)
    df.to_sql(tableName, con, if_exists= 'replace', index= False)
def showTable(tableName):
    print('_'*10+tableName+'_'*10)
    cursor.execute(f'select * from {tableName}')
    for row in cursor.fetchall():
        print(row)
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
def createTableDeleteRows():
    cursor.execute('''
        create table auto_02 as
            select
                t1.auto_key
            from v_auto t1
            left join t_auto t2
            on t1.auto_key = t2.auto_key
            where t2.auto_key is null
    ''')
init()
csv2sql('data.csv', 't_auto')
createTableNewRows()
createTableDeleteRows()
showTable('t_auto')
showTable('auto_01')
showTable('auto_02')