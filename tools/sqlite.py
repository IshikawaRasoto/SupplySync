import sqlite3
import os
from tools import exceptions
from persistqueue.sqlqueue import SQLiteQueue as Queue


class SqliteConfig:
    def __init__(self):
        if not os.path.exists('./res'):
            os.mkdir('./res')
        if not os.path.exists('./res/persistqueue'):
            os.mkdir('./res/persistqueue')
            self.db_queue = Queue("./res/persistqueue", 'db_queue', multithreading=True, auto_commit=False)

    @staticmethod
    def verify_db():

        try:
            database = sqlite3.connect('res/login_data.db')
            cursor = database.cursor()
            cursor.execute('''
                     CREATE TABLE login_data  (
                            username TEXT NOT NULL ,
                            password TEXT NOT NULL,
                            email TEXT NOT NULL,
                            name TEXT NOT NULL,
                            roles TEXT NOT NULL,
                            PRIMARY KEY (username)
                     );
                ''')
            database.close()
            print("-Banco de dados criado")

        except sqlite3.OperationalError:
            print("-Banco de dados já existe")

    def insert_data (self, data_received):

        try:
            database = sqlite3.connect('res/login_data.db')
            cursor = database.cursor()

            cursor.execute('''
                    INSERT INTO login_data (username, password, email, name, roles) VALUES (?, ?, ?, ?, ?)
                ''', (data_received['username'], data_received['password'], data_received['email'], data_received['name'], data_received['roles']))

            database.commit()
            database.close()

        except sqlite3.IntegrityError as error:
            print(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            print(f"Error File: {error.__traceback__.tb_frame}")
            print(f"Error Line: {error.__traceback__.tb_lineno}")
            raise exceptions.HttpError(404, "Usuario ja existente", "Escolha outro usuario")

    def verify_login(self, data_received):

        database = sqlite3.connect('res/login_data.db')
        cursor = database.cursor()
        cursor.execute('''
                            SELECT * FROM login_data WHERE username = ? and password = ?
                        ''', (
        data_received['username'], data_received['password']))
        result = cursor.fetchone()
        if result:
            print("Login e senha validos.")
            return 1
        else:
            print("Login ou senha invalidos.")
            return 0
        database.close()

    def positive_login_response (self, data_received):
        database = sqlite3.connect('res/login_data.db')
        cursor = database.cursor()
        cursor.execute('''
                                    SELECT email, name, roles FROM login_data WHERE username = ?
                                ''', (
            data_received['username'],))
        result = cursor.fetchone()
        database.close()
        return result
