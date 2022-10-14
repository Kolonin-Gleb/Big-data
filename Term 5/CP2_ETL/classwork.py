import sqlite3
import pandas as pd
import time

con = sqlite3.connect('database.db')
cursor = con.cursor()

# Предполагается, что rep_fraud будет удаляться вместе с временными таблицами (в самом начале скрипта).

# Очистка содержимого временных таблиц
def deleteTMPtables():
    cursor.execute('drop table if exists t_empl')
    cursor.execute('drop table if exists empl_01')
    cursor.execute('drop table if exists empl_02')
    cursor.execute('drop table if exists empl_03')


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
        create table if not exists empl_hist(
            empl_id integer,
            name varchar(128),
            lastname varchar(128),
            salary integer,
            job_id varchar(128),
            deleted_flg integer default 0,
            start_dttm datetime default current_timestamp,
            end_dttm datetime default (datetime('2999-12-31 23:59:59'))
        )
    ''')

    cursor.execute('''
        create view if not exists v_empl as
        select 
            empl_id
            ,name
            ,lastname
            ,salary
            ,job_id
        from empl_hist
        where current_timestamp between start_dttm and end_dttm
    ''')

def initReport():
    cursor.execute('''
        create table if not exists rep_fraud(
            id integer primary key autoincrement,
            cnt_intern int,
            percent_deleted float,
            dttm datetime default current_timestamp
        )
    ''')


def fillReport():
    cursor.execute('''
        insert into rep_fraud
        (cnt_intern, percent_deleted)

        select 
        count(*),

        (select 
        count(*)/(select 
        count(*)
        from empl_hist
        where deleted_flg=0)*100
        from empl_hist
        where deleted_flg=1)


        from empl_hist
        where deleted_flg=0
        and end_dttm = datetime('2999-12-31 23:59:59')
       ''')

'''
1.	Какое количество стажеров являются актуальными на момент загрузки?
(После запуска)
2.	Какой процент от общего числа принятых на работу являются стажеров, которые были уволены?
(не оказались в списках CSV).
'''

# Временная таблица для хранения новой инфы
def createTableNewRows():
    cursor.execute('''
        create table empl_01 as
            select
                t1.*
            from t_empl t1
            left join v_empl t2
            on t1.empl_id = t2.empl_id
            where t2.empl_id is null
    ''')

# Временная таблица для хранения удалённых записей
def createTableDeleteRows():
    cursor.execute('''
        create table empl_02 as
            select
                t1.*
            from v_empl t1
            left join t_empl t2
            on t1.empl_id = t2.empl_id
            where t2.empl_id is null
    ''')

# Временная таблица для хранения изменненных записей
def createTableChangeRows():
    cursor.execute(''' 
        create table empl_03 as
            select
            t1.*
            from t_empl t1
            inner join v_empl t2
            on t1.empl_id = t2.empl_id
            and (
                1 = 0
                or t1.name  <> t2.name
                or t1.lastname  <> t2.lastname
                or t1.salary  <> t2.salary
                or t1.job_id  <> t2.job_id
            )
    ''')

# Обновление исторической таблицы из записей временных
def updateEmplHist():
    # ----------------------------- Первый этап - таблица empl_01
    # INSERT для новых объявлений
    cursor.execute('''
        insert into empl_hist(
            empl_id
            ,name
            ,lastname
            ,salary
            ,job_id
        ) select
            empl_id
            ,name
            ,lastname
            ,salary
            ,job_id
        from empl_01
    ''')

    # ----------------------------- Второй этап - таблица empl_03
    # UPDATE для измененных данных
    cursor.execute('''
        UPDATE empl_hist
        set end_dttm = datetime('now', '-1 second')
        where empl_id in (select empl_id from empl_03)
        and end_dttm = datetime('2999-12-31 23:59:59')
    ''')

    # INSERT для измененных объявлений
    cursor.execute('''
        insert into empl_hist(
            empl_id
            ,name
            ,lastname
            ,salary
            ,job_id
        ) select
            empl_id
            ,name
            ,lastname
            ,salary
            ,job_id
        from empl_03
    ''')

    # ----------------------------- Третий этап - таблица empl_02
    # UPDATE для удаленных объявлений
    cursor.execute('''
        UPDATE empl_hist
        set end_dttm = datetime('now', '-1 second')
        where empl_id in (select empl_id from empl_02)
        and end_dttm = datetime('2999-12-31 23:59:59')
    ''')

    # INSERT для удаленных объявлений
    cursor.execute('''
        insert into empl_hist(
            empl_id
            ,name
            ,lastname
            ,salary
            ,job_id
            ,deleted_flg
        ) select
            empl_id
            ,name
            ,lastname
            ,salary
            ,job_id
            ,1
        from empl_02
    ''')

    con.commit()


init()
initReport()

files = ['DE(7)/employees_01.csv', 'DE(7)/employees_02.csv', 'DE(7)/employees_03.csv']

# Формирование временной таблицы со всеми данными

for file in files:
    print("================ Loading new file ================")
    time.sleep(5) # Задержка типа файл загружается =D

    # Удаление временных таблиц
    deleteTMPtables()

    # Создание временных таблиц
    csv2sql(file, 't_empl')
    createTableNewRows()
    createTableDeleteRows()
    createTableChangeRows()
    updateEmplHist()

    # Вставка записи в отчёт
    fillReport()

    """
    showTable('t_empl')
    showTable('empl_01')
    showTable('empl_02')
    showTable('empl_03')
    showTable('empl_hist')
    """

showTable('rep_fraud')
cursor.execute('drop table if exists rep_fraud') # Удаление прошлой таблицы-отчёта
