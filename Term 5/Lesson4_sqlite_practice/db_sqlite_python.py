'''
Написать функционал по добавлению, изменению и удалению пользователей.
Данные должны храниться в списке, данные о пользователе должны быть в виде словаря (id, имя, фамилия, возраст)
Должны быть реализованы процессы добавления, изменения и удаления пользователей отдельными функциями.
'''

import sqlite3

con = sqlite3.connect("database.db")
curs = con.cursor()

def ask_user() -> str:
    print("Выберите команду:")
    print("1 - добавить пользователя")
    print("2 - изменить пользователя по id") # Полностью, кроме id
    print("3 - удалить пользователя по id")
    print("4 - выход")
    return input().strip()

def enter_user() -> list:
    usr = list()
    print("Введите id пользователя")
    usr.append(int(input()))
    print("Введите name пользователя")
    usr.append(input())
    print("Введите lastname пользователя")
    usr.append(input())
    print("Введите age пользователя")
    usr.append(input())
    return usr

def createTableUsers():
    curs.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id integer primary key autoincrement,
            name varchar(100),
            lastname varchar(100),
            age int
        )
    ''')

def insertUser(user: list):
    curs.execute('''
        INSERT INTO users values (?, ?, ?, ?)
    ''', [user[0], user[1], user[2], user[3]])
    con.commit()

def showTable(table):
    curs.execute(f'''
    SELECT * FROM {table}
    ''')
    print('_*'*4 + table + '_*'*4)
    for row in curs.fetchall():
        print(row)
    print('__'*10)

def selectUser(id: int):
    curs.execute(f'''
        SELECT * FROM users WHERE id = {id}
    ''')
    return curs.fetchone()

def updateUser(user: list):
    curs.execute(f'''
        UPDATE users SET id = {user[0]}, name = "{user[1]}", lastname = "{user[2]}", age = {user[3]}
    ''')
    con.commit()

def deleteUser(id: int):
    curs.execute(f'''
        DELETE FROM users WHERE id = {id}
    ''')
    con.commit()

createTableUsers()
# print("Текущее содержимое БД")
# showTable("users")


action = '0'
while action != '4':
    print("Текущее содержимое БД")
    showTable("users")

    action = ask_user()
    if action == "1":
        insertUser(enter_user())
    elif action == "2": # изменить пользователя по id
        user_id = int(input())
        res = selectUser(user_id)
        if res:
            print("Пользователь найден. Вот инфа о нём:")
            print(*res)
            print("Введите новые данные")
            updateUser(enter_user())
            print("Пользователь обновлён")
        else:
            print("Пользователь с указанным id не найден!")
    elif action == "3": # Удалить пользователя по id
        user_id = int(input())
        deleteUser(user_id)

print("Итоговая БД")
showTable("users")
print("Работа с БД завершена")

