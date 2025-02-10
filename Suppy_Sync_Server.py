import time
from tools import sqlite
from tools import request
from tools import mqtt
from tools import notifications

running = True

items = []


def main():
    print("Iniciando o programa...")
    db = sqlite.SqliteConfig()
    db.verify_db()
    mqtt_obj = mqtt.Mqtt("Thread 1")
    mqtt_obj.start()

    request_obj = request.Requests()

    #noti = notifications.Notification()

    request_obj.app.run(host="0.0.0.0", port=5000)

    mqtt_obj.join()
    print("o cÃ³digo continua funfando")

if __name__ == '__main__':
    main()