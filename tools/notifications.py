import firebase_admin
from tools import logger as log_class
from firebase_admin import credentials, messaging

class Notification:

    def __init__(self):
        
        try:
            self.logger = log_class.Logger().logger_obj
            cred = credentials.Certificate("./tools/firebase.json")
            firebase_admin.initialize_app(cred)
            self.logger.info("Firebase conectado com sucesso!")
        
        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")

    
    def request_cart_noti(self, firebase_token, id):
        message = messaging.Message(
        notification=messaging.Notification(
        title="Drone " + id + " a caminho!",
        body="O Drone " + id + " está indo em sua direção e logo deve chegar!"
        ),
        android=messaging.AndroidConfig(
            notification=messaging.AndroidNotification(
                channel_id="cart_ops"  # Aqui é o local correto para definir o canal
            )
        ),
        data={
            "category": "cart_ops", # Aqui é o local correto para definir o canal
        },
        token= firebase_token,
        )

        response = messaging.send(message)
        print('Successfully sent message:', response)


