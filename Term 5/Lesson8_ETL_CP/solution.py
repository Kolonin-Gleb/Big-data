import sqlite3
import pandas as pd
import time
from os import listdir

con = sqlite3.connect('employess.db')
curs = con.cursor()

def showtable(table):
    print('_-'*10 + table + '_-'*10)
    curs.execute(f'select * from {table}')
    for row in curs.fetchall():
        print(row)

def csv2sql(filePath, tableName):
    df = pd.read_csv(filePath)
    df.to_sql(tableName, con=con, index=False)

def init(): 
    curs.execute('''
    create table if not exists empl_hist (
      id integer primary key autoincrement,
      empl_id integer,
      name varchar(100), 
      lastname varchar(100), 
      salary integer, 
      job_id varchar(100), 
      deleted_flg integer default 0,
      start_dttm datetime default current_timestamp,
      end_dttm datetime default (datetime('2999-12-31 23:59:59'))
     )
    ''')

    curs.execute('''
        create table if not exists rep_fraud (
            id integer primary key autoincrement,
            report_dt datetime default current_timestamp,
            empl_count integer,
            remove_empl varchar(10)
        )
     ''')

    curs.execute('''
        create view if not exists v_empl as
        select
            empl_id,
            name, 
            lastname, 
            salary, 
            job_id
        from empl_hist
        where current_timestamp between start_dttm and end_dttm 
        ''')

def createTableNewRows():
    curs.execute('''
        create table empl_addrow as
            select
                t1.* 
            from t_empl t1
            left join v_empl t2
            on t1.empl_id = t2.empl_id
            where t2.empl_id is null
    ''')

def createTableDeleteRows():
    curs.execute('''
    create table empl_delrow as
        select
            t1.*
        from v_empl t1
        left join t_empl t2
        on t1.empl_id = t2.empl_id
        where t2.empl_id is null
    ''')

def createTableChangeRows():
    curs.execute('''
    create table empl_changerow as
        select
            t1.*  
        from t_empl t1
        inner join v_empl t2
        on t1.empl_id = t2.empl_id
        and (
            t1.name <> t2.name or
            t1.lastname <> t2.lastname or
            t1.salary <> t2.salary or
            t1.job_id <> t2.job_id
            )
            ''')

def updateEmplHist():
    curs.execute('''
    update empl_hist
    set end_dttm = datetime('now', '-1 second')
    where empl_id in (select empl_id from empl_changerow)
    and end_dttm = datetime('2999-12-31 23:59:59')
     ''')

    curs.execute('''
    update empl_hist
    set end_dttm = datetime('now', '-1 second')
    where empl_id in (select empl_id from empl_delrow)
    and end_dttm = datetime('2999-12-31 23:59:59') 
     ''')

    curs.execute('''
    insert into empl_hist(
        empl_id,
        name, 
        lastname, 
        salary, 
        job_id
      ) select 
            empl_id,
            name, 
            lastname, 
            salary, 
            job_id
        from empl_addrow
    ''')

    curs.execute('''
    insert into empl_hist(
        empl_id,
        name, 
        lastname, 
        salary, 
        job_id
        ) select 
            empl_id,
            name, 
            lastname, 
            salary, 
            job_id
        from empl_changerow
    ''')

    curs.execute('''
    insert into empl_hist(
        empl_id,
        name, 
        lastname, 
        salary, 
        job_id,
        deleted_flg
        ) select 
            empl_id,
            name, 
            lastname, 
            salary, 
            job_id,
            1
        from empl_delrow
    ''')
    con.commit()

def deleteTMPTables():
    curs.execute('drop table if exists t_empl')
    curs.execute('drop table if exists empl_addrow')
    curs.execute('drop table if exists empl_delrow')
    curs.execute('drop table if exists empl_changerow')

def update_rep_fraud():
    curs.execute('''
        insert into rep_fraud (empl_count, remove_empl)
        select 
            *
        from (
                select 
                    count(*) as empl_count
                from empl_hist eh 
                where deleted_flg = 0 and end_dttm = '2999-12-31 23:59:59'
                )
        cross join (
                SELECT 
                    (del_empl_cont * 100 / act_empl_count) || '%' as remove_pct
                from (
                    select 
                        count(*) as act_empl_count
                    from (
                    SELECT DISTINCT 
                        empl_id
                    from empl_hist eh )
                )
                cross join (
                    select count(*) as del_empl_cont
                    from empl_hist  
                    where deleted_flg = 1
                )
            )
    ''')
    con.commit()

for i in sorted(listdir()):
    if '.csv' in i:
        deleteTMPTables()
        csv2sql(i, 't_empl')
        init()
        createTableNewRows()
        createTableChangeRows()
        createTableDeleteRows()
        updateEmplHist()
        update_rep_fraud()
        showtable('empl_addrow')
        showtable('empl_delrow')
        showtable('empl_changerow')
        showtable('t_empl')
        showtable('empl_hist')
        showtable('rep_fraud')
        time.sleep(5)

