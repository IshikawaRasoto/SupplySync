import sqlite3
import os
from tools import logger as log_class
from tools import exceptions
from persistqueue.sqlqueue import SQLiteQueue as Queue


class SqliteConfig:
    def __init__(self):

        self.logger = log_class.Logger().logger_obj

        if not os.path.exists('./res'):
            os.mkdir('./res')
        if not os.path.exists('./res/persistqueue'):
            os.mkdir('./res/persistqueue')
            self.db_queue = Queue("./res/persistqueue", 'db_queue', multithreading=True, auto_commit=False)

    def verify_db(self):

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
            self.logger.info("Banco de dados de login criado")

        except sqlite3.OperationalError:
            self.logger.info("Banco de dados de login ja existe")

        try:
            database = sqlite3.connect('res/storage.db')
            cursor = database.cursor()
            cursor.execute('''
                                 CREATE TABLE storage  (
                                        id INTEGER PRIMARY KEY AUTOINCREMENT ,
                                        name TEXT NOT NULL,
                                        quantity INTEGER NOT NULL,
                                        storage_id TEXT NOT NULL
                                 );
                            ''')
            database.close()
            self.logger.info("Banco de dados do armazem criado")

        except sqlite3.OperationalError:
            self.logger.info("Banco de dados do armazem ja existe")

        try:
            database = sqlite3.connect('res/valid_storage.db')
            cursor = database.cursor()
            cursor.execute('''
                                 CREATE TABLE valid_storage  (
                                        id INTEGER PRIMARY KEY AUTOINCREMENT ,
                                        name TEXT NOT NULL
                                 );
                            ''')
            database.close()
            self.logger.info("Banco de dados dos armazem validos criado")

        except sqlite3.OperationalError:
            self.logger.info("Banco de dados do armazem validos ja existe")


        try:
            database = sqlite3.connect('res/carts.db')
            cursor = database.cursor()
            cursor.execute('''
                                 CREATE TABLE carts  (
                                        id TEXT NOT NULL,
                                        origin TEXT NOT NULL,
                                        destination TEXT NOT NULL,
                                        load TEXT NOT NULL,
                                        status TEXT NOT NULL,
                                        battery TEXT NOT NULL,
                                        PRIMARY KEY (id)
                                 );
                            ''')
            
            self.logger.info("Banco de dados dos drones criado")

            cursor.execute('''
                    INSERT INTO carts (id, origin, destination, load, status, battery) VALUES ("1", 'doca1', 'nenhum', 'vazio', 'disponivel', "0")
                ''')
            
            cursor.execute('''
                    INSERT INTO carts (id, origin, destination, load, status, battery) VALUES ("2", 'doca2', 'nenhum', 'vazio', 'disponivel', "0")
                ''')

            database.commit()
            database.close()

        except sqlite3.OperationalError:
            self.logger.info("Banco de dados dos drones ja existe")

    def insert_data(self, data_received):

        try:
            database = sqlite3.connect('res/login_data.db')
            cursor = database.cursor()

            cursor.execute('''
                    INSERT INTO login_data (username, password, email, name, roles) VALUES (?, ?, ?, ?, ?)
                ''', (
            data_received['username'], data_received['password'], data_received['email'], data_received['name'],
            data_received['roles']))

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

    def positive_login_response(self, data_received):
        database = sqlite3.connect('res/login_data.db')
        cursor = database.cursor()
        cursor.execute('''
                                    SELECT email, name, roles FROM login_data WHERE username = ?
                                ''', (
            data_received['username'],))
        result = cursor.fetchone()
        database.close()
        return result

    def update_login_data(self, data_received, flag_admin):

        flags_dict = {
            "senha": None,
            "email": None,
            "nome": None,
            "funcao": None
        }

        database = sqlite3.connect('res/login_data.db')
        cursor = database.cursor()

        cursor.execute('''SELECT roles FROM login_data WHERE username = ?
                                                   ''', (
            data_received['username'],))
        result = cursor.fetchone()
        current_role = result[0]

        if "password" in data_received:
            cursor.execute('''SELECT password FROM login_data WHERE username = ?
                                           ''', (
                data_received['username'],))
            result = cursor.fetchone()

            if result[0] == data_received["password"]:
                cursor.execute('''UPDATE login_data SET password = ? WHERE username = ?
                                                           ''',
                               (data_received['new_password'], data_received['username'],))
                database.commit()

                cursor.execute('''SELECT password FROM login_data WHERE username = ?
                                                           ''', (
                    data_received['username'],))
                result = cursor.fetchone()

                if result[0] != data_received['new_password']:
                    print("Erro ao cadastrar nova senha")
                    flags_dict["senha"] = False

                else:
                    print("Nova senha cadastrada com sucesso")
                    flags_dict["senha"] = True

            else:
                print("senha atual incorreta para alteração")
                flags_dict["senha"] = False

        if "email" in data_received:
            cursor.execute('''UPDATE login_data SET email = ? WHERE username = ?
                                                                      ''',
                           (data_received['email'], data_received['username'],))
            database.commit()

            cursor.execute('''SELECT email FROM login_data WHERE username = ?
                                                                      ''', (
                data_received['username'],))
            result = cursor.fetchone()

            if result[0] != data_received['email']:
                print("Erro ao cadastrar novo email")
                flags_dict["email"] = False

            else:
                print("Novo email cadastrado com sucesso")
                flags_dict["email"] = True

        if "name" in data_received:
            cursor.execute('''UPDATE login_data SET name = ? WHERE username = ?
                                                                                  ''',
                           (data_received['name'], data_received['username'],))
            database.commit()

            cursor.execute('''SELECT name FROM login_data WHERE username = ?
                                                                                  ''', (
                data_received['username'],))
            result = cursor.fetchone()

            if result[0] != data_received['name']:
                print("Erro ao cadastrar novo nome")
                flags_dict["nome"] = False

            else:
                print("Novo nome cadastrado com sucesso")
                flags_dict["nome"] = True

        if "roles" in data_received:
            if flag_admin == True:
                cursor.execute('''UPDATE login_data SET roles = ? WHERE username = ?
                                                                                      ''',
                               (data_received['roles'], data_received['username'],))
                database.commit()

                cursor.execute('''SELECT roles FROM login_data WHERE username = ?
                                                                                                  ''', (
                    data_received['username'],))
                result = cursor.fetchone()

                if result[0] != data_received['roles']:
                    print("Erro ao cadastrar nova função")
                    flags_dict["funcao"] = False

                else:
                    print("Nova função cadastrada com sucesso")
                    flags_dict["funcao"] = True

            else:
                print("O usuário não tem permissão para alterar a função")
                flags_dict["funcao"] = False

        database.close()
        return flags_dict

    def get_username_role(self, username_received):
        database = sqlite3.connect('res/login_data.db')
        cursor = database.cursor()
        cursor.execute('''
                            SELECT roles FROM login_data WHERE username = ? ''', (
            username_received,))
        result = cursor.fetchone()
        database.close()
        if result:
            return result[0]

        else:
            return "error"

    def get_user_data(self, username_received):
        database = sqlite3.connect('res/login_data.db')
        cursor = database.cursor()
        cursor.execute('''
                            SELECT username, email, name, roles FROM login_data WHERE username = ? ''', (
            username_received,))
        result = cursor.fetchone()
        database.close()
        if result:
            return result

        else:
            return "error"


    def get_all_users_names (self):
        database = sqlite3.connect('res/login_data.db')
        cursor = database.cursor()
        cursor.execute('''
                            SELECT username, name FROM login_data;''')
        result = cursor.fetchall()
        database.close()
        if result:
            return result

        else:
            return "error"
        

    def get_all_carts (self):
        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute('''
                            SELECT id, battery, status FROM carts;''')
        result = cursor.fetchall()
        database.close()
        if result:
            return result

        else:
            return "error"

    def get_cart_detail(self, id):
        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute('''
                            SELECT battery, origin, destination, load, status FROM carts WHERE id = ? ''', (
            id,))
        
        result = cursor.fetchone()
        database.close()

        if result:
            return result

        else:
            return "error"
        

    def check_if_status_maintenance(self, id):
        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute('''
                            SELECT status FROM carts WHERE id = ? ''', (
            id,))
        
        result = cursor.fetchone()
        database.close()    

        if result:
            if result[0] == "manutencao":
                return True
            
            else:
                return False

        else:
            return "error"

    def check_if_status_off(self, id):
        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute('''
                            SELECT status, status FROM carts WHERE id = ? ''', (
            id,))
        
        result = cursor.fetchone()
        database.close()    

        if result:
            if result[0] == "desligado":
                return True
            
            else:
                return False

        else:
            return "error"
        
    def update_cart_status_maintenance(self, id):
        
        if (self.check_if_status_maintenance(id) == True):
            database = sqlite3.connect('res/carts.db')
            cursor = database.cursor()
            cursor.execute('''
                    UPDATE carts set status = "disponivel" WHERE id = ?
                ''', (id,))
            
            database.commit()
            database.close()
            
            return "ok1"

        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute('''
                            UPDATE carts set status = "manutencao" WHERE id = ? ''', (
            id,))
        
        database.commit()
        database.close()

        return "ok2"

    def update_cart_status_off(self, id):
        
        if (self.check_if_status_off(id) == True):
            database = sqlite3.connect('res/carts.db')
            cursor = database.cursor()
            cursor.execute('''
                    UPDATE carts set status = "disponivel" WHERE id = ?
                ''', (id,))
            
            database.commit()
            database.close()
            
            return "ok1"

        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute('''
                            UPDATE carts set status = "desligado" WHERE id = ? ''', (
            id,))
        
        database.commit()
        database.close()

        return "ok2"