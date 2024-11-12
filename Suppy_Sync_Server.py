import time
from tools import sqlite
from tools import request
running = True

items = []


def main():
    db = sqlite.SqliteConfig()
    db.verify_db()
    request_obj = request.Requests()
    request_obj.app.run(debug=True)
    print("o código continua funfando")

if __name__ == '__main__':
    main()