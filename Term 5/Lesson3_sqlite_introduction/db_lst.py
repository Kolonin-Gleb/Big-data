'''
Написать функционал по добавлению, изменению и удалению пользователей.
Данные должны храниться в списке, данные о пользователе должны быть в виде словаря (id, имя, фамилия, возраст)
Должны быть реализованы процессы добавления, изменения и удаления пользователей отдельными функциями.
'''

def ask_user() -> str:
    print("Выберите команду:")
    print("1 - добавить пользователя")
    print("2 - изменить пользователя по id") # Полностью, кроме id
    print("3 - удалить пользователя по id")
    print("4 - выход")
    return input().strip()

def enter_user() -> dict:
    usr = dict()
    print("Введите id пользователя")
    usr["id"] = int(input())
    print("Введите name пользователя")
    usr["name"] = input()
    print("Введите lastname пользователя")
    usr["lastname"] = input()
    print("Введите age пользователя")
    usr["age"] = input()
    return usr

action = '0'
db = []

# Словари добавляются в начало FILO

while action != '4':
    action = ask_user()
    if action == "1":
        db.append(enter_user())
    elif action == "2": # изменить пользователя по id
        find_id = int(input())
        for dct_id in range(len(db)):
            if db[dct_id]["id"] != find_id:
                continue
            print("Пользователь найден. Вот инфа о нём:")
            print(db[dct_id])
            print("Введите новые данные")
            db[dct_id] = enter_user()
    elif action == "3": # Удалить пользователя по id
        find_id = int(input())
        for dct_id in range(len(db)):
            if db[dct_id]["id"] != find_id:
                continue
            print("Произвожу удаление по id")
            db.pop(dct_id)

print("Итоговая БД")
print(db)
print("Работа с БД завершена")

