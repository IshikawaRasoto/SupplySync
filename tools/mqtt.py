import paho.mqtt.client as mqtt
import networkx as nx
from threading import Thread
import time

BROKER = "srv689391.hstgr.cloud"  # Endereço do seu broker MQTT
CARRO_ID = "carro1"

class Mqtt(Thread):
    def __init__(self, nome):
        super().__init__()
        # Criando o Grafo do Layout
        self.G = nx.DiGraph()  # Grafo Direcionado

        # Definição dos nós (Pontos Importantes)
        self.G.add_nodes_from([
            "Armazem1", "Armazem2", "Doca1", "Doca2", "Manutencao", 
            "Interseccao1", "Interseccao2", "Interseccao3", "Interseccao4", "Interseccao5"
        ])

        # Conexões entre os pontos (arestas com pesos)
        self.G.add_edge("Armazem1", "Interseccao1", weight=1)
        self.G.add_edge("Interseccao1", "Interseccao2", weight=1)
        self.G.add_edge("Interseccao2", "Armazem2", weight=1)

        self.G.add_edge("Interseccao1", "Interseccao3", weight=1)
        self.G.add_edge("Interseccao2", "Interseccao5", weight=1)

        self.G.add_edge("Interseccao3", "Doca1", weight=1)
        self.G.add_edge("Interseccao3", "Interseccao4", weight=1)
        self.G.add_edge("Interseccao4", "Doca2", weight=1)
        self.G.add_edge("Interseccao5", "Interseccao4", weight=1)

        self.G.add_edge("Interseccao5", "Manutencao", weight=1)

        self.nome = nome
        self.client = mqtt.Client()
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message

    def on_connect(self, client, userdata, flags, rc):
        print(f"Thread {self.nome}: Conectado ao broker MQTT ({BROKER}) com código {rc}")
        
        # Inscreve-se no tópico para receber dados da ESP32
        topico_telemetria = f"carrinhos/{CARRO_ID}/telemetria"
        client.subscribe(topico_telemetria)
        print(f"Thread {self.nome}: Inscrito no tópico {topico_telemetria}")

    def on_message(self, client, userdata, msg):
        print(f"Thread {self.nome}: Mensagem recebida no tópico {msg.topic}: {msg.payload.decode()}")

    def enviar_comando(self, comando):
        topico_comando = f"carrinhos/{CARRO_ID}/comandos"
        self.client.publish(topico_comando, comando)
        print(f"Thread {self.nome}: Comando enviado: {comando}")

    def run(self):
        print(f"Thread {self.nome} iniciada.")

        #self.client.connect(BROKER, 1883, 60)
        #self.client.loop_start()  # Mantém a conexão ativa
        
        while True:
            #comando = input("Digite um comando para enviar ao carrinho: ")
            #self.enviar_comando(comando)
            self.retorna_caminho()
            return
            #time.sleep(1)


    # Função para calcular a rota ótima
    def calcular_rota(self, origem, destino):
        try:
            caminho = nx.shortest_path(self.G, source=origem, target=destino, weight="weight")
            return caminho
        except nx.NetworkXNoPath:
            return None
        
    def retorna_caminho(self):

        origem = "Armazem1"
        destino = "Doca1"
        rota = self.calcular_rota(origem, destino)

        if rota:
            print(f"Rota para o carrinho: {' -> '.join(rota)}")
        else:
            print("Nenhum caminho encontrado!")

        origem = "Armazem1"
        destino = "Doca2"
        rota = self.calcular_rota(origem, destino)
        
        print(rota)
        print(type(rota))

        if rota:
            print(f"Rota para o carrinho: {' -> '.join(rota)}")
        else:
            print("Nenhum caminho encontrado!")

        origem = "Armazem1"
        destino = "Manutencao"
        rota = self.calcular_rota(origem, destino)

        if rota:
            print(f"Rota para o carrinho: {' -> '.join(rota)}")
        else:
            print("Nenhum caminho encontrado!")
        
        origem = "Armazem1"
        destino = "Armazem2"
        rota = self.calcular_rota(origem, destino)

        if rota:
            print(f"Rota para o carrinho: {' -> '.join(rota)}")
        else:
            print("Nenhum caminho encontrado!")




