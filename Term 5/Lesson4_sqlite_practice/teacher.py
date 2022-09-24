import sqlite3
con = sqlite3.connect('database.db')
curs = con.cursor()

def initTableGoods():
    curs.execute('''
        create table if not exists users (
          id integer primary key autoincrement,
          name varchar(100),
          last_name varchar(100),
          age int
        )
    ''')

def insertDataUesrs(data1, data2,data3):
    curs.execute('''
    insert into users (name, last_name, age) values (?,?,?)
    ''', [data1,data2, data3])
    con.commit()

def deleteRowUsers(id):
    curs.execute('''
    delete from users
    where id = ?
    ''',[id])
    con.commit()

def updateRowUser(id, name, lastname,age):
    curs.execute('''
    update users
    set name = ?, last_name = ?, age = ?
    where id = ?
    ''',[name,lastname,age,id])
    con.commit()

def showTable(table):
    curs.execute(f'''
    select * from {table}
    ''')
    print('_*'*4 + table + '_*'*4)
    for row in curs.fetchall():
        print(row)
    print('_*'*10)

# initTableGoods()
# insertDataUesrs('Tigran', 'Movsisyan', 32)
# insertDataUesrs('Alex', 'Wilyam', 15)
# updateRowUser(2,'Alex', 'Krasnov', 40)
deleteRowUsers(2)
showTable('users')

