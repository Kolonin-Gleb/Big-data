# Паттерны хранения данных

import sqlite3

con = sqlite3.connect("database.db")
cursor = con.cursor()


def init_table_employees():
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS employees (
            id integer primary key autoincrement,
            name varchar(128),
            last_name varchar(128),
            salary float,
            job_name varchar,
            deleted_flg integer DEFAULT 0
        )
    ''')

    # Создание представления, что будет отражать только активных продуктов (не deleted_flg)
    cursor.execute('''
        CREATE VIEW IF NOT EXISTS v_employees as
        select id, name, last_name, salary, job_name FROM employees WHERE deleted_flg = 0 
    ''')


def deleteRowEmployee(id):
    cursor.execute('''
        UPDATE employees SET deleted_flg = 1 WHERE id = ?
    ''', [id])
    con.commit()


def repairRowEmployee(id):
    cursor.execute('''
        UPDATE employees SET deleted_flg = 0 WHERE id = ?
    ''', [id])
    con.commit()


def addRowEmployee(id, name, last_name, salary, job_name):
    cursor.execute('''
        INSERT INTO employees (id, name, last_name, salary, job_name) VALUES (?, ?, ?, ?, ?)
    ''', [id, name, last_name, salary, job_name])
    con.commit()


def showTable(table):
    cursor.execute(f"SELECT * FROM {table}")

    for row in cursor.fetchall():
        print(row)


init_table_employees()
addRowEmployee(1, "Max", "Dudkin", 900, 'engineer')
addRowEmployee(2, "Vasily", "Bobkov", 1200, 'chess player')
addRowEmployee(3, "Dmitry", "juravlev", 2000, 'leader')

showTable("employees")
print("========================")
showTable("v_employees")

print("\n\n\n\n\n\n")

deleteRowEmployee(1)

showTable("employees")
print("========================")
showTable("v_employees")

print("\n\n\n\n\n\n")

repairRowEmployee(1)

showTable("employees")
print("========================")
showTable("v_employees")

print("\n\n\n\n\n\n")


'''

'''