# pip install psycopg2
import psycopg2
import pandas as pd

sql = open('big data\sql.txt', 'r')
sql = str(sql.read())
sql = sql.replace("XXXX", "tgss")
sql = sql.replace("public", "p3")
sql = sql.replace('"', "")
sql = sql.split(';')

sql_tgss_STG_terminals = sql[0]
sql_tgss_STG_transactions = sql[1]
sql_tgss_STG_passport_blacklist = sql[2]
sql_tgss_STG_cards = sql[3]
sql_tgss_STG_clients = sql[4]
sql_tgss_STG_accounts = sql[5]
sql_tgss_STG_DEL_cards = sql[6]
sql_tgss_STG_DEL_clients = sql[7]
sql_tgss_STG_DEL_transactions = sql[8]
sql_tgss_STG_DEL_accounts = sql[9]
sql_tgss_STG_DEL_terminals = sql[10]
sql_tgss_STG_DEL_passport_blacklist = sql[11]

# print(sql_tgss_STG_DEL_passport_blacklist)

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

passport_blacklist_01 = pd.read_excel(r'big data\data\passport_blacklist_01032021.xlsx')
passport_blacklist_02 = pd.read_excel(r'big data\data\passport_blacklist_02032021.xlsx')
passport_blacklist_03 = pd.read_excel(r'big data\data\passport_blacklist_03032021.xlsx')
terminals_01 = pd.read_excel(r'big data\data\terminals_01032021.xlsx')
terminals_02 = pd.read_excel(r'big data\data\terminals_02032021.xlsx')
terminals_03 = pd.read_excel(r'big data\data\terminals_03032021.xlsx')
transactions_01 = pd.read_csv(r'big data\data\transactions_01032021.txt', delimiter=';')
transactions_02 = pd.read_csv(r'big data\data\transactions_01032021.txt', delimiter=';')
transactions_03 = pd.read_csv(r'big data\data\transactions_01032021.txt', delimiter=';')

# dicts = {}
# dicts['transaction_id'] = []
# dicts['transaction_date'] = []
# dicts['amount'] = []
# dicts['card_num'] = []
# dicts['oper_type'] = []
# dicts['oper_result'] = []
# dicts['terminal'] = []

# for ind, values in transactions_01.iterrows():
#     dicts['transaction_id'].append(values['transaction_id'])
#     dicts['transaction_date'].append(values['transaction_date'])
#     dicts['card_num'].append(values['card_num'])
#     dicts['oper_type'].append(values['oper_type'])
#     dicts['oper_result'].append(values['oper_result'])
#     dicts['terminal'].append(values['terminal'])
#     a = values['amount']
#     a = float(a.replace(',', '.'))
#     print(type(a))
#     dicts['amount'].append(values['amount'])

# df_test = pd.DataFrame(dicts)
# print(df_test)
# transactions_01.astype({'amount': 'float'})

# print(transactions_01)
# print(df_test.info())

# Создание STG таблиц 
# cursor.execute(sql_tgss_STG_terminals)
# cursor.execute(sql_tgss_STG_transactions)
# cursor.execute(sql_tgss_STG_accounts)
# cursor.execute(sql_tgss_STG_cards)
# cursor.execute(sql_tgss_STG_clients)
# cursor.execute(sql_tgss_STG_passport_blacklist)
# cursor.execute(sql_tgss_STG_DEL_accounts)
# cursor.execute(sql_tgss_STG_DEL_cards)
# cursor.execute(sql_tgss_STG_DEL_clients)
# cursor.execute(sql_tgss_STG_DEL_passport_blacklist)
# cursor.execute(sql_tgss_STG_DEL_terminals)
# cursor.execute(sql_tgss_STG_DEL_transactions)
# conn.commit()
# cursor.execute('Drop table p3.tgss_STG_passport_blacklist')
# cursor.execute('Drop table p3.tgss_STG_transactions')
# cursor.execute('Drop table p3.tgss_STG_DEL_terminals')
# cursor.execute(sql_tgss_STG_passport_blacklist)
# cursor.execute(sql_tgss_STG_transactions)
# cursor.execute(sql_tgss_STG_DEL_terminals)
# conn.commit()

# # Занесение данных
# cursor.executemany( "INSERT INTO p3.tgss_STG_transactions( transaction_id, transaction_date, amount, card_name, oper_type, oper_result, terminal) VALUES( %s, %s, %s, %s, %s, %s, %s )", transactions_01.values.tolist() )
# conn.commit()

# # Выполнение SQL кода в базе данных с возвратом результата
# cursor.execute( "SELECT * FROM p3.tgss_STG_transactions" )
# records = cursor.fetchall()
# for row in records:
#     print( row )