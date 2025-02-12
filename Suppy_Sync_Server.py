import time
from tools import sqlite
from tools import request
from tools import mqtt

running = True

items = []


def main():
    print("Iniciando o programa...")
    db = sqlite.SqliteConfig()
    db.verify_db()
    #mqtt_obj = mqtt.Mqtt("Thread 1")
    #mqtt_obj.start()

    request_obj = request.Requests()

    request_obj.app.run(host="0.0.0.0", port=5000)

    #mqtt_obj.join()
    print("o codigo continua funcionando")

if __name__ == '__main__':
    main()