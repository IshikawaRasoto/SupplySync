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


    def item_add_noti(self, data, firebase_token, id):
        message = messaging.Message(
        notification=messaging.Notification(
        title="Um item foi adicionado",
        body="O item " + data["name"] + " foi adicionado ao Armazem " + id 
        ),
        android=messaging.AndroidConfig(
            notification=messaging.AndroidNotification(
                channel_id="inventory"  # Aqui é o local correto para definir o canal
            )
        ),
        data={
            "category": "inventory", # Aqui é o local correto para definir o canal
        },
        token= firebase_token,
        )

        response = messaging.send(message)
        print('Successfully sent message:', response)

    def item_update_noti(self, data, firebase_token, id):
        message = messaging.Message(
        notification=messaging.Notification(
        title="Um item foi alterado!",
        body="O item " + data["name"] + " foi alterado ao Armazem " + id
        ),
        android=messaging.AndroidConfig(
            notification=messaging.AndroidNotification(
                channel_id="inventory"  # Aqui é o local correto para definir o canal
            )
        ),
        data={
            "category": "inventory", # Aqui é o local correto para definir o canal
        },
        token= firebase_token,
        )

        response = messaging.send(message)
        print('Successfully sent message:', response)

    def item_delete_noti(self, data, firebase_token, id):
        message = messaging.Message(
        notification=messaging.Notification(
        title="Um item foi excluído!",
        body="O item com id " + str(data["id"]) + " foi excluído ao Armazem " + id
        ),
        android=messaging.AndroidConfig(
            notification=messaging.AndroidNotification(
                channel_id="inventory"  # Aqui é o local correto para definir o canal
            )
        ),
        data={
            "category": "inventory", # Aqui é o local correto para definir o canal
        },
        token= firebase_token,
        )

        response = messaging.send(message)
        print('Successfully sent message:', response)
    
    
    def first_release_noti(self, warehouse, firebase_token, id):
        message = messaging.Message(
        notification=messaging.Notification(
        title="Drone " + id + " a caminho!",
        body="O Drone " + id + " está indo para o " + warehouse
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

    
    def maintenance_noti(self, firebase_token, id):
        message = messaging.Message(
        notification=messaging.Notification(
        title="Drone " + id + " precisa de manutenção!",
        body="O Drone " + id + " está indo para a manutenção"
        ),
        android=messaging.AndroidConfig(
            notification=messaging.AndroidNotification(
                channel_id="maintenance"  # Aqui é o local correto para definir o canal
            )
        ),
        data={
            "category": "maintenance", # Aqui é o local correto para definir o canal
        },
        token= firebase_token,
        )

        response = messaging.send(message)
        print('Successfully sent message:', response)

    def create_login_noti(self, data, firebase_token):
        message = messaging.Message(
        notification=messaging.Notification(
        title="Um usuário novo foi criado!",
        body="O usuário " + data["username"] + " com a função " + data["roles"] + " foi criado!"
        ),
        android=messaging.AndroidConfig(
            notification=messaging.AndroidNotification(
                channel_id="user_actions"  # Aqui é o local correto para definir o canal
            )
        ),
        data={
            "category": "user_actions", # Aqui é o local correto para definir o canal
        },
        token= firebase_token,
        )

        response = messaging.send(message)
        print('Successfully sent message:', response)