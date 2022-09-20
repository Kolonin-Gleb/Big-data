# pip install db-sqlite3
# pip install pandas


import sqlite3

conn = sqlite3.connect('lesson.db') # файл БД

# Создание курсор для взаимодействия с БД
curs = conn.cursor()

"""
curs.execute('''
    CREATE TABLE test(
        id int,
        name varchar(100)
    );
''')
"""

curs.execute('''
    INSERT INTO test VALUES (1, "Gleb");
''')

# Сохранение изменений в БД
conn.commit()

curs.execute('''
    SELECT * FROM test;
''')
result = curs.fetchall() # Получение результата последнего запроса.
descips = curs.description

print(result)

# Названия столбцов
for i in descips:
    print(i[0])

