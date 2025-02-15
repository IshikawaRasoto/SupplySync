import paho.mqtt.client as mqtt
import networkx as nx
from threading import Thread
from tools import sqlite
from tools import logger as log_class
import time

BROKER = "srv689391.hstgr.cloud"  # Endereço do seu broker MQTT
CARRO_ID = "carro1"
BATTERY_ID = "battery1"

class Mqtt(Thread):
    def __init__(self, nome):
        super().__init__()
        # Criando o Grafo do Layout

        self.db = sqlite.SqliteConfig()
        self.logger = log_class.Logger().logger_obj

        self.G = nx.DiGraph()  # Grafo Direcionado

        # Definição dos nós (Pontos Importantes)
        self.G.add_nodes_from([
            "Armazem 1", "Armazem 2", "Doca 1", "Doca 2", "manutencao", 
            "inter1", "inter2", "inter3", "inter4", "inter5"
        ])

        # Conexões entre os pontos (arestas com pesos)

        self.G.add_edge("Armazem 1", "inter1", weight=1)
        self.G.add_edge("inter1", "Armazem 1", weight=1)
        
        self.G.add_edge("inter1", "inter2", weight=1)
        self.G.add_edge("inter2", "inter1", weight=1)
        
        self.G.add_edge("inter2", "Armazem 2", weight=1)
        self.G.add_edge("Armazem 2", "inter2", weight=1)

        self.G.add_edge("inter1", "inter3", weight=1)
        self.G.add_edge("inter3", "inter1", weight=1)

        self.G.add_edge("inter5", "inter2", weight=1)
        self.G.add_edge("inter2", "inter5", weight=1)

        self.G.add_edge("inter3", "Doca 1", weight=1)
        self.G.add_edge("Doca 1", "inter3", weight=1) 

        self.G.add_edge("inter3", "inter4", weight=1)
        self.G.add_edge("inter4", "inter3", weight=1)

        self.G.add_edge("inter4", "Doca 2", weight=1)
        self.G.add_edge("Doca 2", "inter4", weight=1)
        
        self.G.add_edge("inter5", "inter4", weight=1)
        self.G.add_edge("inter4", "inter5", weight=1)

        self.G.add_edge("inter5", "manutencao", weight=1)
        self.G.add_edge("manutencao", "inter5", weight=1)

        self.nome = nome
        self.client = mqtt.Client()
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message

        self.route = None

        self.table = {
            "inter1": [ 
                {"origin": "Armazem 1", "destiny": "inter2", "maneuver": "L"},
                {"origin": "Armazem 1", "destiny": "inter3", "maneuver": "R"},
                {"origin": "inter2", "destiny": "Armazem 1", "maneuver": "R"},
                {"origin": "inter2", "destiny": "inter3", "maneuver": "L"},
                {"origin": "inter3", "destiny": "inter2", "maneuver": "R"},
                {"origin": "inter3", "destiny": "Armazem 1", "maneuver": "L"}
            ],
            "inter2": [
                {"origin": "Armazem 2", "destiny": "inter1", "maneuver": "R"},
                {"origin": "Armazem 2", "destiny": "inter5", "maneuver": "L"},
                {"origin": "inter1", "destiny": "Armazem 2", "maneuver": "L"},
                {"origin": "inter1", "destiny": "inter5", "maneuver": "R"},
                {"origin": "inter5", "destiny": "inter1", "maneuver": "L"},
                {"origin": "inter5", "destiny": "Armazem 2", "maneuver": "R"}
            ],
            "inter3": [
                {"origin": "Doca 1", "destiny": "inter1", "maneuver": "L"},
                {"origin": "Doca 1", "destiny": "inter4", "maneuver": "R"},
                {"origin": "inter1", "destiny": "Doca 1", "maneuver": "R"},
                {"origin": "inter1", "destiny": "inter4", "maneuver": "L"},
                {"origin": "inter4", "destiny": "Doca 1", "maneuver": "L"},
                {"origin": "inter4", "destiny": "inter1", "maneuver": "R"}
            ],
            "inter4": [
                {"origin": "Doca 2", "destiny": "inter5", "maneuver": "R"},
                {"origin": "Doca 2", "destiny": "inter3", "maneuver": "L"},
                {"origin": "inter5", "destiny": "Doca 2", "maneuver": "L"},
                {"origin": "inter5", "destiny": "inter3", "maneuver": "R"},
                {"origin": "inter3", "destiny": "Doca 2", "maneuver": "R"},
                {"origin": "inter3", "destiny": "inter5", "maneuver": "L"}
            ],
            "inter5": [
                {"origin": "manutencao", "destiny": "inter2", "maneuver": "R"},
                {"origin": "manutencao", "destiny": "inter4", "maneuver": "L"},
                {"origin": "inter2", "destiny": "manutencao", "maneuver": "L"},
                {"origin": "inter2", "destiny": "inter4", "maneuver": "R"},
                {"origin": "inter4", "destiny": "inter2", "maneuver": "L"},
                {"origin": "inter4", "destiny": "manutencao", "maneuver": "R"}
            ]
        }

        self.update_route()

    def on_connect(self, client, userdata, flags, rc):
        print(f"Thread {self.nome}: Conectado ao broker MQTT ({BROKER}) com código {rc}")
        
        # Inscreve-se no tópico para receber dados da ESP32

        topico_telemetria = f"cars/{CARRO_ID}/telemetria"
        client.subscribe(topico_telemetria)
        print(f"Thread {self.nome}: Inscrito no tópico {topico_telemetria}")

        topico_telemetria = f"cars/{CARRO_ID}/cruzamento"
        client.subscribe(topico_telemetria)
        print(f"Thread {self.nome}: Inscrito no tópico {topico_telemetria}")

    def on_message(self, client, userdata, msg):

        mensagem = msg.payload.decode()

        if msg.topic == f"cars/{CARRO_ID}/telemetria":
            print(f"Mensagem recebida do tópico battery: {mensagem}")
            percentil = ((int(mensagem) - 20000)/10000)*100
            self.db.update_battery(percentil)

        elif msg.topic == f"cars/{CARRO_ID}/cruzamento":
            print(f"Mensagem recebida do tópico cruzamento: {mensagem}")
            self.send_command(self.choose_direction())

        else:
            print(f"Mensagem recebida no tópico {msg.topic}: {mensagem}")        


    def send_command(self, comando):
        topico_comando = f"cars/{CARRO_ID}/comandos"
        self.client.publish(topico_comando, comando)
        print(f"Thread {self.nome}: Comando enviado: {comando}")

    def run(self):
        print(f"Thread {self.nome} iniciada.")

        self.client.connect(BROKER, 1883, 60)
        self.client.loop_start()  # Mantém a conexão ativa
        
        while True:
            #self.retorna_caminho()
            
            time.sleep(1)


    # Função para calcular a rota ótima
    def routing(self, origin, destiny):
        try:
            '''print(origin)
            print(destiny)
            print(self.G.nodes)
            print(self.G.edges)'''
            self.route = nx.shortest_path(self.G, source=origin, target=destiny, weight="weight")
            print(self.route)
            
        except nx.NetworkXNoPath:
            self.route = None
        
    def retorna_caminho(self):

        '''origin = "Armazem 1"
        destiny = "manutencao"
        self.routing(origin, destiny)
        
        while self.route != None:
            print(self.route)
            self.choose_direction()'''
        
        self.update_route()
        while self.route != None:
            print(self.route)
            self.choose_direction()


    def update_route(self):
        try:
            result = self.db.get_origin_destiny()   
            print(result)

            if result[2] == "nenhum":
                
                self.routing(result[0], result[1])

            else:
                self.routing(result[0], result[2])

        except Exception as error:
            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")


    def choose_direction(self):

        try:
            
            if len(self.route) >= 3:

                if self.route[1] == "inter1":
                    for item in self.table["inter1"]:
                        if self.route[0] == item ["origin"] and self.route[2] == item ["destiny"]:
                            print("maneuver -----------------------11111")
                            print(item["maneuver"])
                            self.route.pop(0)
                            return item["maneuver"]

                elif self.route[1] == "inter2":
                    for item in self.table["inter2"]:
                        if self.route[0] == item ["origin"] and self.route[2] == item ["destiny"]:
                            print("maneuver -----------------------22222")
                            print(item["maneuver"])
                            self.route.pop(0)
                            return item["maneuver"]
                        
                elif self.route[1] == "inter3":
                    for item in self.table["inter3"]:
                        if self.route[0] == item ["origin"] and self.route[2] == item ["destiny"]:
                            print("maneuver -----------------------33333")
                            print(item["maneuver"])
                            self.route.pop(0)
                            return item["maneuver"]
                
                elif self.route[1] == "inter4":
                    for item in self.table["inter4"]:
                        if self.route[0] == item ["origin"] and self.route[2] == item ["destiny"]:
                            print("maneuver -----------------------44444")
                            print(item["maneuver"])
                            self.route.pop(0)
                            return item["maneuver"]
                        
                elif self.route[1] == "inter5":
                    for item in self.table["inter5"]:
                        if self.route[0] == item ["origin"] and self.route[2] == item ["destiny"]:
                            print("maneuver -----------------------55555")
                            print(item["maneuver"])
                            self.route.pop(0)
                            return item["maneuver"]
                

            else:
                print("Acabou o self.route")
                self.route = None
                return "P"

        except Exception as error:

            self.logger.error(type(error))
            self.logger.error(f"Error Type: {error.__traceback__.tb_frame.f_locals.get('error', None)}")
            self.logger.error(f"Error File: {error.__traceback__.tb_frame}")
            self.logger.error(f"Error Line: {error.__traceback__.tb_lineno}")
        

        
        


