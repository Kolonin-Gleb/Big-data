import sqlite3 as sql
import pandas as pd
import datetime as dt


class DataBase:
    def __init__(self, database_path = "database.db"):
        self.database_path = database_path
        self.__connection = sql.connect(self.database_path)
        self.__cursor = self.__connection.cursor()
        self.init_table()


    def __execute(self, sql):
        self.__cursor.execute(sql)
        self.__connection.commit()


    def __get(self):
        return self.__cursor.fetchone()


    def __get_all(self):
        return self.__cursor.fetchall()


    def init_table(self):
        self.__execute("""
            create table if not exists users (
                id integer primary key autoincrement,
                name varchar(128),
                surname varchar(128),
                age integer,
                salary float,
                start_dt datetime default current_timestamp,
                end_dt datetime default (datetime('2999-12-31 23:59:59')),
                active integer default 1
            )
        """)


    def get_user(self, name: str, surname: str):
        self.__execute(f"""
            select * from users
            where name = '{name}' and surname = '{surname}' and end_dt = (datetime('2999-12-31 23:59:59'))
        """)
        return self.__get()


    def add_user(self, name: str, surname: str, age: int, salary: float):
        self.__execute(f"""
            update users
            set end_dt = datetime('now', '-1 second')
            where name = '{name}' and surname = '{surname}' and end_dt = (datetime('2999-12-31 23:59:59'))
        """)

        self.__execute(f"""
            insert into users 
            (name, surname, age, salary) 
            values 
            ('{name}', '{surname}', {age}, {salary});
        """)


    def remove_user(self, name: str, surname: str):
        self.__execute(f"""
            select age, salary 
            from users 
            where name = '{name}' and surname = '{surname}' and end_dt = (datetime('2999-12-31 23:59:59'))
        """)

        row = self.__get()
        age = row[0]
        salary = row[1]

        self.__execute(f"""
            update users
            set end_dt = datetime('now', '-1 second')
            where name = '{name}' and surname = '{surname}' and end_dt = (datetime('2999-12-31 23:59:59'))
        """)

        self.__execute(f"""
            insert into users 
            (name, surname, age, salary, active) 
            values 
            ('{name}', '{surname}', {age}, {salary}, {0});
        """)


    def get_table(self):
        self.__execute("select * from users;")
        return self.__get_all()
            

    def save_to_csv(self, dt = dt.datetime.now()):
        sql = f"""
            select * 
            from users
            where '{dt}' < end_dt and '{dt}' > start_dt;
        """

        df = pd.read_sql(sql, self.__connection)
        df.to_csv('users.csv', index = False)

