# pip install psycopg2
# pip install openpyxl
import psycopg2
import pandas as pd

# Создание подключения к PostgreSQL
conn = psycopg2.connect(database = "home",
                        host =     "212.8.247.94",
                        user =     "student",
                        password = "qwerty",
                        port =     "5432")

# Отключение автокоммита
conn.autocommit = False

# Создание курсора
cursor = conn.cursor()
####################################################
# Выполнение SQL кода в базе данных без возврата результата
cursor.execute( "INSERT INTO p3.testtable( id, val ) VALUES ( 3, 'GLEB' )" )
conn.commit()

# Выполнение SQL кода в базе данных с возвратом результата
cursor.execute( "SELECT * FROM p3.testtable" )
records = cursor.fetchall()
for row in records:
    print( row )

####################################################

# Формирование DataFrame
names = [ x[0] for x in cursor.description ]
df = pd.DataFrame( records, columns = names )

# Запись в файл
df.to_excel( 'pandas_out.xlsx', sheet_name='sheet1', header=True, index=False )

####################################################
# Чтение из файла
df = pd.read_excel( 'pandas_in.xlsx', sheet_name='sheet1', header=0, index_col=None )

# Запись DataFrame в таблицу базы данных
cursor.executemany( "INSERT INTO p3.testtable( id, val ) VALUES( %s, %s )", df.values.tolist() )
conn.commit()
# Закрываем соединение
cursor.close()
conn.close()

