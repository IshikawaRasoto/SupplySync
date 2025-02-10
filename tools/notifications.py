import firebase_admin
from firebase_admin import credentials, messaging

class Notification:

    def __init__(self):

        cred = credentials.Certificate("./tools/firebase.json")
        firebase_admin.initialize_app(cred)

        print("Firebase conectado com sucesso!")

        message = messaging.Message(
        notification=messaging.Notification(
        title="Atualização de Estoque!",
        body="maintenance teste"
        ),
        android=messaging.AndroidConfig(
            notification=messaging.AndroidNotification(
                channel_id="maintenance"  # Aqui é o local correto para definir o canal
            )
        ),
        data={
            "category": "maintenance", # Aqui é o local correto para definir o canal
            "productId": "product_x_123"
        },
        token= "cT_KZR6OTlmbYX5TpD3NaJ:APA91bHpyxO8rXbSqLxKHpuHPwodAbuu21NdeuLn9Ce_M2xXkKYIKhbPmOSAkPE-2XOuyu9OHOh14VWasK2TNEswZvG1tP0-Ot24VEyXDVuyY2CQDeJ1fd8",
        )

        response = messaging.send(message)
        print('Successfully sent message:', response)


