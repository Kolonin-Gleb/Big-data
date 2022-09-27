# Паттерны хранения данных

import sqlite3

con = sqlite3.connect("database.db")
cursor = con.cursor()

def init_table_product():
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS products (
            id integer primary key autoincrement,
            title varchar(128),
            price integer,
            deleted_flg integer DEFAULT 0
        )
    ''')

    # Создание представления, что будет отражать только активных продуктов (не deleted_flg)
    cursor.execute('''
        CREATE VIEW IF NOT EXISTS v_products as
        select id, title, price FROM products WHERE deleted_flg = 0 
    ''')
    
def deleteRowProduct(id):
    cursor.execute('''
        UPDATE prodcuts SET deleted_flg = 1 WHERE id = ?
    ''', [id])
    con.commit()

def repairRowProduct(id):
    cursor.execute('''
        UPDATE prodcuts SET deleted_flg = 0 WHERE id = ?
    ''', [id])
    con.commit()

def addRowProduct(title, price):
    cursor.execute('''
        INSERT INTO products (title, price) VALUES (?, ?)
    ''', [title, price])
    con.commit()


def showTable(table):
    cursor.execute(f"SELECT * FROM {table}")

    for row in cursor.fetchall():
        print(row)

    
init_table_product()
# addRowProduct('velosiped', 10000)
# addRowProduct('samokat', 3000)
# addRowProduct('roliki', 7000)
# addRowProduct('racketka', 600)

showTable("products")
print("========================")
showTable("v_products")
