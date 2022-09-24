import sqlite3

con = sqlite3.connect("database.db")

curs = con.cursor()

"""

curs.execute('''
    CREATE TABLE goods (
        name varchar(100),
        quantity int
    )
''')

# Вставка данных в таблицу из python объекта
lst = ['bike', 3]

curs.execute('''
    INSERT INTO goods values (?, ?)
''', [lst[0], lst[1]])

con.commit() # Для сохранения изм. в БД

# Метод executemany для вставки данных в таблицу до тех пор, пока в массиве есть значения
g = [
    [1, 1],
    [2, 1],
    [3, 1],
    [4, 1],
]

curs.executemany('''
    INSERT INTO goods values (?, ?)
''', g)

"""

# con.commit() # Для сохранения изм. в БД


curs.execute('''
    SELECT * FROM goods
''')

print(curs.fetchall())
