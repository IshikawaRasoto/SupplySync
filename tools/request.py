import secrets
import string
from tools import sqlite
from tools import exceptions
from flask import Flask, jsonify, request
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity

class Requests:
    def __init__(self):
        simbols = string.ascii_letters + string.digits + string.punctuation
        token = ''.join(secrets.choice(simbols) for _ in range(12))
        self.app = Flask(__name__)
        self.app.config['jwt_token'] = token
        self.jwt = JWTManager(self.app)
        self.db = sqlite.SqliteConfig()

        # Definindo as rotas dentro do construtor
        self.app.add_url_rule('/login', view_func=self.verify_login, methods=['POST'])
        self.app.add_url_rule('/create_login', view_func=self.create_login, methods=['POST'])

    def verify_login(self):

        try:
            data = request.get_json()
            result = self.db.verify_login((data))
            if result:
                secret_key = self.app.config['jwt_token']
                print(secret_key)
                result = self.db.positive_login_response(data)
                result_final = jsonify({'jwt_token': secret_key, 'email': result[0], 'name': result[1], 'roles': result[2]})
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
            return "Login criado", 201  # Retornando uma string e um código de status

        except exceptions.HttpError as error:
            return error.to_json(), error.error_json['error']['code']

        except Exception as error:
            ex = exceptions.HttpError(401,"Dados invalidos", "Faltaram dados")
            print(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            print(f"Error File: {error.__traceback__.tb_frame}")
            print(f"Error Line: {error.__traceback__.tb_lineno}")
            return ex.to_json(), ex.error_json['error']['code']