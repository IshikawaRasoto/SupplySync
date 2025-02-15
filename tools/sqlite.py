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
            
            self.logger.info("Banco de dados de login criado")

            cursor.execute('''
                INSERT INTO login_data (username, password, email, name, roles) VALUES ("adm", "123", "adm@email.com", "admin", "admin")
            ''')

            database.commit()
            database.close()

        except sqlite3.OperationalError:
            self.logger.info("Banco de dados de login ja existe")

        try:
            database = sqlite3.connect('res/warehouse.db')
            cursor = database.cursor()
            cursor.execute('''
                                 CREATE TABLE warehouse  (
                                        id INTEGER PRIMARY KEY AUTOINCREMENT ,
                                        name TEXT NOT NULL,
                                        description TEXT NOT NULL,
                                        quantity INTEGER NOT NULL,
                                        unit TEXT NOT NULL,
                                        storage_id INTEGER NOT NULL
                                 );
                            ''')
            database.close()
            self.logger.info("Banco de dados do armazem criado")

        except sqlite3.OperationalError:
            self.logger.info("Banco de dados do armazem ja existe")

        try:
            database = sqlite3.connect('res/valids_warehouses.db')
            cursor = database.cursor()
            cursor.execute('''
                                 CREATE TABLE valids_warehouses  (
                                        id INTEGER PRIMARY KEY AUTOINCREMENT ,
                                        name TEXT NOT NULL
                                 );
                            ''')
            
            cursor.execute('''
                INSERT INTO valids_warehouses (name) VALUES ("Armazem 1")
            ''')
            cursor.execute('''
                INSERT INTO valids_warehouses (name) VALUES ("Armazem 2")
            ''')

            database.commit()
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
                                        load_qnt TEXT NOT NULL,
                                        status TEXT NOT NULL,
                                        battery TEXT NOT NULL,
                                        destination_temp TEXT NOT NULL,
                                        PRIMARY KEY (id)
                                 );
                            ''')
            
            self.logger.info("Banco de dados dos drones criado")

            cursor.execute('''
                    INSERT INTO carts (id, origin, destination, load, load_qnt, status, battery, destination_temp) VALUES ("1", 'Armazem 1', 'nenhum', 'vazio', "0", 'disponivel', "50", 'nenhum')
                ''')
            
            cursor.execute('''
                    INSERT INTO carts (id, origin, destination, load, load_qnt, status, battery, destination_temp) VALUES ("2", 'Armazem 2', 'nenhum', 'vazio', "0", 'disponivel', "50", 'nenhum')
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
        database.close()

        if result:
            print("Login e senha validos.")
            return 1
        else:
            print("Login ou senha invalidos.")
            return 0
        
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
                    UPDATE carts set status = "disponivel", destination = "nenhum", origin = "manutencao" WHERE id = ?
                ''', (id,))
            
            database.commit()
            database.close()
            
            return "ok1"

        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute('''
                            UPDATE carts set status = "manutencao", destination = "manutencao" WHERE id = ? ''', (
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
    
    def update_cart_status_running(self, id, data):

        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute('''
                UPDATE carts set status = "ocupado", destination = ?, load = ?, load_qnt= ?, destination_temp = ? WHERE id = ?
            ''', (data["destination"], data["load"], data["loadQuantity"], data["origin"], id,))
        
        database.commit()
        database.close()
        


    def check_available_carts(self):

        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute('''
                        SELECT id FROM carts WHERE status = "disponivel" ''')
        result = cursor.fetchall()
    
        database.close()    

        if result: 
            return result
        
        else:
            return "error"
    
    def warehouse_get_incoming_drones(self, id, warehouse):

        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute(''' SELECT id, battery FROM carts WHERE destination = ? AND destination_temp = "nenhum" ''', (warehouse,))

        result = cursor.fetchall()

        database.close()   

        if result: 
            return result
        
        else:
            return "no_carts"


    def request_cart(self, data):

        available_carts = self.check_available_carts()

        if available_carts:
           self.update_cart_status_running(available_carts[0][0], data)
           return available_carts[0][0]

        else:
            return "no_available"
        

    def release_cart(self, id):

        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute('''
                            SELECT destination, destination_temp FROM carts WHERE id = ? ''', (
            id,))
        result = cursor.fetchone()

        var = 0

        if result:
            if result[1] != "nenhum":
                cursor.execute('''UPDATE carts set destination_temp = "nenhum", origin = ? WHERE id = ? ''', (result[1], id,))
                database.commit()
                var = 1

            else:
                if result [0] != "nenhum":
                    cursor.execute('''UPDATE carts set destination = "nenhum", status = "disponivel", load = "vazio", load_qnt = "0", origin = ? WHERE id = ? ''', (result[0], id,))
                    database.commit()   
                    var = 2
        
        database.close()
        return var

        

    def get_warehouses(self):
        
        database = sqlite3.connect('res/valids_warehouses.db')
        cursor = database.cursor()
        cursor.execute(''' SELECT id, name FROM valids_warehouses''')

        result = cursor.fetchall()
        database.close()

        if result:
            return result
        
        else:
            return "error"
         
    def warehouse_add_item (self, data, id):

        database = sqlite3.connect('res/warehouse.db')
        cursor = database.cursor()
        cursor.execute('''INSERT INTO warehouse (name, description, quantity, unit, storage_id) VALUES (?, ?, ?, ?, ?)''', 
                       (data["name"], data["description"], data["quantity"], data["unit"], id))

        database.commit()  
        database.close()

    def warehouse_get_products (self, id):

        database = sqlite3.connect('res/warehouse.db')
        cursor = database.cursor()
        cursor.execute('''SELECT id, name, description, quantity, unit FROM warehouse WHERE storage_id = ? ''', (
            id,))
        
        result = cursor.fetchall()
        database.close()

        if result:
            return result
        
        else:
            return "error"
        
    def warehouse_update_item (self, data, id):

        database = sqlite3.connect('res/warehouse.db')
        cursor = database.cursor()
        cursor.execute('''UPDATE warehouse set name = ?, description = ?, quantity = ?, unit = ? WHERE id = ? ''', (data["name"], data["description"], data["quantity"], data["unit"], data["id"]))
        
        database.commit()  
        database.close()

    def warehouse_delete_item (self, data):

        database = sqlite3.connect('res/warehouse.db')
        cursor = database.cursor()
        cursor.execute('''DELETE FROM warehouse WHERE id = ?''', (data["id"],))
        
        database.commit()  
        database.close()


    def get_warehouse_by_cart (self, id):

        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute('''SELECT destination FROM carts WHERE id = ? ''', (
            id,))
        
        result = cursor.fetchone()
        database.close()

        if result:
            return result
        
        else:
            return "error"
        

    def get_origin_destiny(self):

        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute('''SELECT origin, destination, destination_temp FROM carts WHERE id = 1 ''')
        
        result = cursor.fetchone()
        database.close()

        if result:
            return result
        
        else:
            return "error"
        

    def update_battery(self, value):

        database = sqlite3.connect('res/carts.db')
        cursor = database.cursor()
        cursor.execute('''UPDATE carts set battery = ? WHERE id = 1''', (value,))
        
        database.commit()
        database.close()


    