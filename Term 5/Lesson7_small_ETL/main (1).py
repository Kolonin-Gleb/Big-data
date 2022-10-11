import sqlite3

con = sqlite3.connect('database.db')
cursor = con.cursor()

def init_table_product():
    cursor.execute('''
        create table if not exists product(
            id integer primary key autoincrement,
            title varchar(128),
            price integer,
            deleted_flg integer default 0
        )
    ''')

    cursor.execute('''
        create view if not exists v_product as
        select id, title, price
        from product
        where deleted_flg = 0
    ''')

def deleteRowProduct(id):
    cursor.execute('''
        update product
        set deleted_flg = 1
        where id = ?
    ''',[id])
    con.commit()

def repairRowProduct(id):
    cursor.execute('''
        update product
        set deleted_flg = 0
        where id = ?
    ''',[id])
    con.commit()


def addRowProduct(title, price):
    cursor.execute('''
        insert into product (title, price) values (?,?)
    ''',[title, price])
    con.commit()

def showTable(table):
    print('_*'*10)
    cursor.execute(f'select * from {table}')
    for row in cursor.fetchall():
        print(row)
    print('_*'*10)

init_table_product()
# addRowProduct('velik', 10000)
# addRowProduct('samokat', 3000)
# addRowProduct('roliki', 5000)
# addRowProduct('skateboard', 7000)
# addRowProduct('raketka', 600)
# deleteRowProduct(1)
# deleteRowProduct(2)
# deleteRowProduct(3)
repairRowProduct(3)
showTable('product')

showTable('v_product')


# Реализуйте процесс логического удаления для следующих сущностей:
# Таблица сотрудников с атрибутами:

# id,
# name,
# last_name,
# salary,
# job_name.

# Продемонстрируйте выполнение логического удаления, востановления и записи новых данных в таблцу