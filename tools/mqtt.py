from threading import Thread
import time


class Mqtt(Thread):
    def __init__(self, nome):
        super().__init__()
        self.nome = nome

    def run(self):
        print(f'Thread {self.nome} iniciada.')
        ##for i in range(5):
          ##  print(f'Thread {self.nome} está executando: {i}')
          ##  time.sleep(1)  # Simula um trabalho que leva tempo
        print(f'Thread {self.nome} finalizada.')
