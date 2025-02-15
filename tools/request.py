import secrets
import string
import os
from tools import logger as log_class
from tools import sqlite
from tools import exceptions
from flask import Flask, jsonify, request
from tools import notifications
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from datetime import datetime
from tools import mqtt

active_tokens = list()

os.environ["FLASK_ENV"] = "production"


class Requests:
    def __init__(self):
        self.app = Flask(__name__)
        self.jwt = JWTManager(self.app)
        self.db = sqlite.SqliteConfig()

        self.logger = log_class.Logger().logger_obj
        self.noti = notifications.Notification()

        self.logger.info(("---------SISTEMA INICIADO---------"))

        self.mqtt_obj = mqtt.Mqtt("Thread 1")
        self.mqtt_obj.start()

        # Definindo as rotas dentro do construtor
        self.app.add_url_rule('/login', view_func=self.verify_login, methods=['POST'])
        self.app.add_url_rule('/create_login', view_func=self.create_login, methods=['POST'])
        self.app.add_url_rule('/cart_request', view_func=self.cart_request, methods=['POST'])
        self.app.add_url_rule('/cart_shutdown/<id>', view_func=self.cart_shutdown, methods=['POST'])
        self.app.add_url_rule('/cart_maintenance/<id>', view_func=self.cart_maintenance, methods=['POST'])
        self.app.add_url_rule('/upload_drone_photo/<id>', view_func=self.upload_drone_photo, methods=['POST'])
        self.app.add_url_rule('/release_cart/<id>', view_func=self.release_cart, methods=['POST'])
        self.app.add_url_rule('/warehouses/<id>', view_func=self.warehouse_add_item, methods=['POST'])
        self.app.add_url_rule('/cart_problem/<id>', view_func=self.cart_problem, methods=['POST'])
        self.app.add_url_rule('/update_login', view_func=self.update_login, methods=['PUT'])
        self.app.add_url_rule('/warehouses/<id>', view_func=self.warehouse_update_item, methods=['PUT'])
        self.app.add_url_rule('/get_user/<username>', view_func=self.get_user, methods=['GET'])
        self.app.add_url_rule('/get_myself', view_func=self.get_myself, methods=['GET'])
        self.app.add_url_rule('/get_all_users', view_func=self.get_all_users, methods=['GET'])
        self.app.add_url_rule('/get_logs', view_func=self.get_logs, methods=['GET'])
        self.app.add_url_rule('/get_carts', view_func=self.get_carts, methods=['GET'])
        self.app.add_url_rule('/cart_details/<id>', view_func=self.cart_details, methods=['GET'])
        self.app.add_url_rule('/warehouses', view_func=self.get_warehouses, methods=['GET'])
        self.app.add_url_rule('/warehouses/<id>', view_func=self.get_warehouse_products, methods=['GET'])
        self.app.add_url_rule('/warehouses/incoming_drones/<id>', view_func=self.get_warehouses_incoming_drones, methods=['GET'])
        self.app.add_url_rule('/logout', view_func=self.logout, methods=['DELETE'])
        self.app.add_url_rule('/warehouses/<id>', view_func=self.warehouse_delete_item, methods=['DELETE'])


        UPLOAD_FOLDER = './uploads'
        os.makedirs(UPLOAD_FOLDER, exist_ok=True)  # Garante que a pasta exista
        self.app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


    def verify_jwt_token(self, token):
        self.clear_token()
        for item in active_tokens:
            token_in_list = list(item.keys())[0]
            print("TOKEN IN LIST: " + token_in_list)
            print("TOKEN IN RECEIVED: " + token)
            if "Bearer " + token_in_list == token:
                print("TOKENS IGUAIS")
                return True
        print("TOKENS DIFF")
        return False

    def clear_token(self):
        ##print("active_tokens ANTES:")
        ##print(active_tokens)
        for item in active_tokens:
            token_time_str = list(item.values())[0][2]
            token_time_num = datetime.strptime(token_time_str, "%H:%M")

            time_now = datetime.strptime(datetime.now().strftime("%H:%M"), "%H:%M")
            diff_time = time_now - token_time_num
            print(diff_time.total_seconds())
            type(diff_time.total_seconds())
            if diff_time.total_seconds() >= 3600:
                ##print(list(item.keys())[0])
                active_tokens.remove(item)

        ##print("active_tokens DEPOIS:")
        ##print(active_tokens)

    def update_login(self):

        try:   
            flag_admin = True

            print("ENTROU FUNC UPDATE LOGIN")
            data = request.headers
            print("DATA dentro de UPDATE LOGIN: " + str(data))

            if not self.verify_jwt_token(data.get('Authorization', '')):  # Usa .get() para evitar erro se 'Authorization' não existir
                raise exceptions.HttpError(401, "JWT TOKEN inválido", "JWT TOKEN inválido")

            if self.get_roles_by_jwt_token(data['Authorization']) != "admin":
                flag_admin = False

            data = request.get_json()
            print("DATA dentro de UPDATE LOGIN (BODY): " + str(data))

            flags_dict = self.db.update_login_data(data, flag_admin) 

            text = ""
            
            for key, value in flags_dict.items():
                if value is not None:  
                    if value:  
                        text += f"{key} alterado com sucesso"
                    else:
                        raise exceptions.HttpError(400, "Erro ao alterar", f"Erro ao alterar {key}")

            response = jsonify({'status': text})
            return response, 200
        
        except exceptions.HttpError as error:  
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(f"Error Type: {type(error).__name__}")
            self.logger.error(f"Error Message: {error}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']


    def verify_login(self):

        try:
            data = request.get_json()
            result = self.db.verify_login((data))

            if result:
                self.clear_token()

                # for item in active_tokens:
                # if list(item.values())[0][0] == data['username']:
                #      response = jsonify({'status': "Usuário já logado"})
                #       return response, 200

                simbols = string.ascii_letters + string.digits + string.punctuation
                token = ''.join(secrets.choice(simbols) for _ in range(12))
                self.app.config['jwt_token'] =token
                secret_key = self.app.config['jwt_token']

                result = self.db.positive_login_response(data)

                result_final = jsonify(
                    {'jwt_token': secret_key, 'username': data['username'], 'email': result[0], 'name': result[1],
                     'roles': result[2]})

                for item in active_tokens:
                    key, value = list(item.items())[0]  
                    if data['firebase_token'] in value: 
                        active_tokens.remove(item)

                new_item = {secret_key: (data['username'], result[2], datetime.now().strftime("%H:%M"), data['firebase_token'])}
                active_tokens.append(new_item)

                print("ACTIVE TOKENS FINAL")
                print(active_tokens)
                print("JSON enviado")
                print(result_final)
                return result_final, 200

            else:
                ex = exceptions.HttpError(400, "Dados invalidos", "Dados invalidos")
                return ex.to_json(), ex.error_json['error']['code']


        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "Dados invalidos", "Erro generico")
            return ex.to_json(), ex.error_json['error']['code']

    def create_login(self):

        try:
            data = request.headers
            if not self.verify_jwt_token(data['Authorization']):
                raise exceptions.HttpError(401, "JWT TOKEN inválido", "JWT TOKEN inválido")
            
            if self.get_roles_by_jwt_token(data['Authorization']) != "admin":
                raise exceptions.HttpError(400, "Usuário não é admin", "Usuário não é admin")

            data = request.get_json()
            self.db.insert_data(data)
            for item in active_tokens:
                key, value = list(item.items())[0] 
                if "admin" in value:
                    self.noti.create_login_noti(data, value[3])
            response = jsonify({'status': "Login Criado"})
            return response, 200  

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "Dados invalidos", "Faltaram dados")
            return ex.to_json(), ex.error_json['error']['code']

    def get_user(self, username):

        try:
            data = request.headers
            print("GETUSER DATA HEADER: " + str(data))
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")
            
            if self.get_roles_by_jwt_token(data['Authorization']) != "admin":
                raise exceptions.HttpError(400, "Usuário não é admin", "Usuário não é admin")

            result = self.db.get_user_data(username)

            if result == "error":
                raise exceptions.HttpError(400, "Usuário não encontrado", "Usuário não encontrado")

            result_final = jsonify(
                {'username': result[0], 'email': result[1], 'name': result[2], 'roles': result[3]})
            return result_final, 200

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']
        
        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']

    def get_roles_by_jwt_token(self, token):
        self.clear_token()
        for item in active_tokens:
            token_in_list = list(item.keys())[0]
            if "Bearer " + token_in_list == token:
                data = item[token_in_list]
                print("Dado retornado na func get_role: "+data[1])
                return data[1]
        return "not_found"
    

    def get_myself(self):

        try:
            data = request.headers
            print("GETUSER DATA HEADER: " + str(data))
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")
            
            for item in active_tokens:
                token_in_list = list(item.keys())[0]
                if "Bearer " + token_in_list == data['Authorization']:
                    data = item[token_in_list]
                    result = self.db.get_user_data(data[0])

                    if result == "error":  
                        raise exceptions.HttpError(401, "Usuário não encontrado", "Usuário não encontrado")
                        
                    result_final = jsonify(
                        {'username': result[0], 'email': result[1], 'name': result[2], 'roles': result[3]})  
                    return result_final, 200
        
        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']
        
    def get_all_users(self):
        
        try:
            data = request.headers
            print("GETUSER DATA HEADER: " + str(data))
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")
            
            if self.get_roles_by_jwt_token(data['Authorization']) != "admin":
                raise exceptions.HttpError(401, "Usuário não é admin", "Usuário não é admin")

            result = self.db.get_all_users_names()
            print("GET ALL USER RESULT:")
            print(result)
            print(type(result))


            users = [{"username": user[0], "name": user[1]} for user in result]

            return jsonify({"users": users}), 200


        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']
        
    def logout(self):
        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")
            
            data_w_bearer = data['Authorization'].replace("Bearer ", "").strip()

            for item in active_tokens:
                if data_w_bearer in item:
                    active_tokens.remove(item)
                    response = jsonify({'status': "Logout realizado"})
                    return response, 200  

            raise exceptions.HttpError(401, "Usuário não encontrado", "Usuário não encontrado")
                    
        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']

    def get_logs(self):
        try:
            data = request.headers
            
            # Verifica o token JWT
            if not self.verify_jwt_token(data.get('Authorization', '')):
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")
            
            # Defina o caminho do arquivo de log
            log_file_path = os.path.join('./logs', "supply_sync.log")
            
            # Lê todas as linhas do arquivo e pega as últimas 20
            with open(log_file_path, "r", encoding="utf-8") as file:
                all_lines = file.readlines()
            last_lines = all_lines[-20:]
            
            logs_list = []
            for line in last_lines:
                # Exemplo de linha:
                # "2025-02-04 01:25:08,148 - INFO - 177.62.205.200 - - [04/Feb/2025 01:25:08] \"POST /login HTTP/1.1\" 200 -"
                parts = line.strip().split(" - ")
                if len(parts) < 3:
                    continue  # Pula linhas que não seguem o formato esperado
                
                # Extrai e formata a data (removendo os milissegundos e convertendo para dd/mm/yy hh:mm:ss)
                date_str = parts[0].split(",")[0]  # "2025-02-04 01:25:08"
                try:
                    dt = datetime.strptime(date_str, "%Y-%m-%d %H:%M:%S")
                    formatted_date = dt.strftime("%d/%m/%y %H:%M:%S")
                except Exception:
                    formatted_date = date_str  # Caso a conversão falhe, mantém o valor original
                
                # O nível vem na segunda parte, convertendo para minúsculas
                level = parts[1].lower()
                
                # O restante da linha forma o corpo da mensagem
                body = " - ".join(parts[2:])
                
                # Define a origem: se a mensagem contém "POST /login" ou "DELETE /logout", considera "user", senão "server"
                source = "server"
                if "POST /login" in body or "DELETE /logout" in body:
                    source = "user"
                
                log_entry = {
                    "date": formatted_date,
                    "level": level,
                    "source": source,
                    "body": body
                }
                logs_list.append(log_entry)
            
            response = jsonify({"logs": logs_list})
            return response, 200

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']
 
    def get_carts(self):

        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")
            
            if self.get_roles_by_jwt_token(data['Authorization']) != "admin" and self.get_roles_by_jwt_token(data['Authorization']) != "manutencao":
                raise exceptions.HttpError(400, "Usuário não é admin", "Usuário não é admin")

            result = self.db.get_all_carts()
            carts = [{"id": cart[0], "battery": cart[1], "status": cart[2]} for cart in result]

            return jsonify({"carts": carts}), 200
                    
        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']


    def cart_details(self, id):

        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")

            result = self.db.get_cart_detail(id)

            result_final = jsonify(
                {'id': id, 'battery': result[0], 'origin': result[1], 'destination': result[2], 'load': result[3], 'status': result[4]})
            return result_final, 200

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']

    def cart_request(self):
        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")
            
            jwt_token = data['Authorization']

            data = request.get_json()

            result = self.db.request_cart(data)

            if result != "no_available":
                data_w_bearer = jwt_token.replace("Bearer ", "").strip()
                for item in active_tokens:
                    if data_w_bearer in item:  
                        firebase_token = item[data_w_bearer][3]  
                self.noti.request_cart_noti(firebase_token, result)
                response = jsonify({'id': result})
                return response, 200  

            raise exceptions.HttpError(400, "Não existe carrinhos disponíveis", "Não existe carrinhos disponíveis")

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(401, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']        


    def cart_shutdown(self, id):   
        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")

            result = self.db.update_cart_status_off(id)

            if result == "ok1" or result == "ok2":
                response = jsonify({'status': "Alteração realizada com sucesso!"})
                return response, 200  

            raise exceptions.HttpError(401, "Algum erro aconteceu", "Algum erro aconteceu")

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']

    def cart_maintenance(self, id):
        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")

            result = self.db.update_cart_status_maintenance(id)
            print("RESULT- ------------------ "+ result)
            if result == "ok1" or result == "ok2":
                if result == "ok2":
                    for item in active_tokens:
                        key, value = list(item.items())[0] 
                        if "admin" in value or "manutencao" in value:
                            self.noti.maintenance_noti(value[3], id)
                response = jsonify({'status': "Alteração realizada com sucesso!"})
                return response, 200  

            raise exceptions.HttpError(401, "Algum erro aconteceu", "Algum erro aconteceu")

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']


    def upload_drone_photo(self, id):

        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")

            if 'image' not in request.files:
                raise exceptions.HttpError(401, "Não foi encaminhada uma imagem", "Não foi encaminhada uma imagem")

            image = request.files['image'] 

            image.filename = id + "_" + datetime.now().strftime("%H-%M-%S") + ".jpg"
        
            file_path = os.path.join(self.app.config['UPLOAD_FOLDER'], image.filename)
            image.save(file_path)  

            return jsonify({"status": "Imagem recebida com sucesso", "file_path": file_path}), 200

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']


    def release_cart(self, id):
        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")

            result = self.db.release_cart(id)

            warehouse = self.db.get_warehouse_by_cart(id)

            if result == 1:
                for item in active_tokens:
                    key, value = list(item.items())[0] 
                    if "admin" in value or "armazem" in value:
                        self.noti.first_release_noti(warehouse[0], value[3], id)

            return jsonify({"status": "Carrinho liberado!"}), 200

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']

    def get_warehouses(self):

        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")

            result = self.db.get_warehouses()

            all_warehouses = [{"id": warehouse[0], "name": warehouse[1]} for warehouse in result]

            return jsonify({"warehouses": all_warehouses}), 200

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']
        
    
    def warehouse_add_item(self, id):

        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")
            
            data = request.get_json()

            result = self.db.warehouse_add_item(data, id)

            for item in active_tokens:
                key, value = list(item.items())[0] 
                if "admin" in value or "armazem" in value:
                    self.noti.item_add_noti(data, value[3], id)

            return jsonify({"status": "Produto adicionado!"}), 200

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']
        

    def get_warehouse_products(self, id):

        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")

            result = self.db.warehouse_get_products(id)

            if result != "error":
                all_products = [{"id": product[0], "name": product[1], "description": product[2], "quantity": product[3], "unit": product[4]} for product in result]
                return jsonify({"products": all_products}), 200

            return jsonify({"products": []}), 200
            

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']

    def warehouse_update_item(self, id):

        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")
            
            data = request.get_json()

            result = self.db.warehouse_update_item(data, id)

            for item in active_tokens:
                key, value = list(item.items())[0] 
                if "admin" in value or "armazem" in value:
                    self.noti.item_update_noti(data, value[3], id)

            return jsonify({"status": "Produto alterado com sucesso!"}), 200

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']

    def warehouse_delete_item(self, id):

        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")

            data = request.get_json()

            result = self.db.warehouse_delete_item(data)

            for item in active_tokens:
                key, value = list(item.items())[0] 
                if "admin" in value or "armazem" in value:
                    self.noti.item_delete_noti(data, value[3], id)

            return jsonify({"status": "Produto excluido com sucesso!"}), 200

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']
        
    def get_warehouses_incoming_drones(self, id):

        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")

            warehouse = ""
        
            if id == "1":
                warehouse = "Armazem 1"
            
            elif id == "2":
                warehouse = "Armazem 2"

            print("--------")
            print(id)
            print(warehouse)
            result = self.db.warehouse_get_incoming_drones(id, warehouse)

            if result != "no_carts":
                carts = [{"id": cart[0], "battery": cart[1]} for cart in result]
                return jsonify({"carts": carts}), 200

            else:
                return jsonify({"carts": ""}), 200

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']
        

    def cart_problem (self, id):

        try:
            data = request.headers
            if self.verify_jwt_token(data['Authorization']) == False:
                raise exceptions.HttpError(401, "Usuário não autorizado", "Usuário não autorizado")

            data = request.get_json()

            self.logger.warning ("O drone " + id + " foi reportado com o seguinte problema: " + data["problem"])

            return jsonify({"status": "Problema relatado com sucesso"}), 200

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
            ex = exceptions.HttpError(400, "ERRO", "Verificar log do servidor para detalhes")
            return ex.to_json(), ex.error_json['error']['code']