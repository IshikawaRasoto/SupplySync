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
    mqtt_obj = mqtt.Mqtt("Thread 1")
    mqtt_obj.start()

    request_obj = request.Requests()
    request_obj.app.run()

    mqtt_obj.join()
    print("o código continua funfando")

if __name__ == '__main__':
    main()


