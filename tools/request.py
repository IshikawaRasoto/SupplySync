import secrets
import string
from tools import logger as log_class
from tools import sqlite
from tools import exceptions
from flask import Flask, jsonify, request
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from datetime import datetime

active_tokens = list()

class Requests:
    def __init__(self):
        self.app = Flask(__name__)
        self.jwt = JWTManager(self.app)
        self.db = sqlite.SqliteConfig()

        self.logger = log_class.Logger().logger_obj

        self.logger.info(("---------SISTEMA INICIADO---------"))

        # Definindo as rotas dentro do construtor
        self.app.add_url_rule('/login', view_func=self.verify_login, methods=['POST'])
        self.app.add_url_rule('/create_login', view_func=self.create_login, methods=['POST'])
        self.app.add_url_rule('/update_login', view_func=self.update_login, methods=['PUT'])
        self.app.add_url_rule('/get_user/<username>', view_func=self.get_user, methods=['GET'])


    def verify_jwt_token(self, token):
        self.clear_token()
        for item in active_tokens:
            token_in_list = list(item.keys())[0]
            if token_in_list == token:
                return True
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
            if diff_time.total_seconds() >= 900:
                ##print(list(item.keys())[0])
                active_tokens.remove(item)

        ##print("active_tokens DEPOIS:")
        ##print(active_tokens)

    def update_login(self):

        data = request.headers

        if not self.verify_jwt_token(data['Authorization']):
            response = jsonify({'status': "Usuário não autorizado"})
            return response


        data = request.get_json()
        self.db.update_login_data(data)
        response = jsonify({'status': "Alteração realizada com sucesso"})

        return response, 200


    def verify_login(self):

        try:
            data = request.get_json()
            result = self.db.verify_login((data))

            if result:
                self.clear_token()

                for item in active_tokens:
                    if list(item.values())[0][0] == data['username']:
                        response = jsonify({'status': "Usuário já logado"})
                        return response, 200

                simbols = string.ascii_letters + string.digits + string.punctuation
                token = ''.join(secrets.choice(simbols) for _ in range(12))
                self.app.config['jwt_token'] = token
                secret_key = self.app.config['jwt_token']

                result = self.db.positive_login_response(data)

                result_final = jsonify({'jwt_token': secret_key, 'email': result[0], 'name': result[1], 'roles': result[2]})

                new_item = {secret_key: (data['username'], result[2], datetime.now().strftime("%H:%M"))}
                active_tokens.append(new_item)

                print("ACTIVE TOKENS FINAL")
                print(active_tokens)
                return result_final, 200

            else:
                ex = exceptions.HttpError(401, "Dados invalidos", "Dados invalidos")
                return ex.to_json(), ex.error_json['error']['code']


        except Exception as error:
            ex = exceptions.HttpError(401, "Dados invalidos", "Erro generico")
            print(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            print(f"Error File: {error.__traceback__.tb_frame}")
            print(f"Error Line: {error.__traceback__.tb_lineno}")
            return ex.to_json(), ex.error_json['error']['code']

    def create_login(self):

        try:
            data = request.get_json()
            self.db.insert_data(data)
            response = jsonify({'status': "Login Criado"})
            return response, 201  # Retornando uma string e um código de status

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            ex = exceptions.HttpError(401,"Dados invalidos", "Faltaram dados")
            print(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            print(f"Error File: {error.__traceback__.tb_frame}")
            print(f"Error Line: {error.__traceback__.tb_lineno}")
            return ex.to_json(), ex.error_json['error']['code']

    def get_user(self, username):
        print("Username recebido "+username)
        return "Ok", 200


