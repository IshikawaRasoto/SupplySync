#include "define.h"

/*

#include <WiFi.h>
#include <PubSubClient.h>
#define WIFI_SSID "RasotoVivo"
#define WIFI_PASS "Rasoto1570"
#define MQTT_BROKER "srv689391.hstgr.cloud"
#define MQTT_PORT 1883
#define CARRO_ID "carro1"

WiFiClient espClient;
PubSubClient client(espClient);

void mqtt_callback(char* topic, byte* payload, unsigned int length) {
    Serial.print("Comando recebido no tópico: ");
    Serial.println(topic);
    Serial.print("Dados: ");
    
    for (int i = 0; i < length; i++) {
        Serial.print((char)payload[i]);
    }
    Serial.println();
}

void setup_wifi() {
    Serial.print("Conectando ao WiFi: ");
    Serial.println(WIFI_SSID);
    WiFi.begin(WIFI_SSID, WIFI_PASS);
    
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.print(".");
    }
    Serial.println("\nWiFi conectado!");
}

void reconnect_mqtt() {
    while (!client.connected()) {
        Serial.print("Tentando conectar ao broker MQTT...");
        if (client.connect(CARRO_ID)) {
            Serial.println("Conectado!");

            String topico_comandos = "carrinhos/" + String(CARRO_ID) + "/comandos";
            client.subscribe(topico_comandos.c_str());
        } else {
            Serial.print("Falha, rc=");
            Serial.print(client.state());
            Serial.println(" Tentando novamente em 5 segundos...");
            delay(5000);
        }
    }
}

void setup() {
    Serial.begin(115200);
    setup_wifi();
    
    client.setServer(MQTT_BROKER, MQTT_PORT);
    client.setCallback(mqtt_callback);
}

void loop() {
    if (!client.connected()) {
        reconnect_mqtt();
    }
    client.loop();

    String topico_telemetria = "carrinhos/" + String(CARRO_ID) + "/telemetria";
    client.publish(topico_telemetria.c_str(), "velocidade:12.5");

    delay(5000);
}

*/

/*
MOTOR_INPUT_1 - roda direita para tras
MOTOR_INPUT_2 - roda direita para frente
MOTOR_INPUT_3 - roda esquerda para tras
MOTOR_INPUT_4 - roda esquerda para frente
*/

#define NUM_SENSORS 5
const int sensorPins[NUM_SENSORS] = {34, 15, 13, 14, 33};
const int sensorWeights[NUM_SENSORS] = {-2, -1, 0, 1, 2};

void go_forward(){
    digitalWrite(MOTOR_INPUT_1, LOW);
    digitalWrite(MOTOR_INPUT_2, HIGH);
    digitalWrite(MOTOR_INPUT_3, LOW);
    digitalWrite(MOTOR_INPUT_4, HIGH);
}

void go_left(){
    digitalWrite(MOTOR_INPUT_1, LOW);
    digitalWrite(MOTOR_INPUT_2, HIGH);
    digitalWrite(MOTOR_INPUT_3, LOW);
    digitalWrite(MOTOR_INPUT_4, LOW);
}

void go_right(){
    digitalWrite(MOTOR_INPUT_1, LOW);
    digitalWrite(MOTOR_INPUT_2, LOW);
    digitalWrite(MOTOR_INPUT_3, LOW);
    digitalWrite(MOTOR_INPUT_4, HIGH);
}

void stand_still(){
    digitalWrite(MOTOR_INPUT_1, LOW);
    digitalWrite(MOTOR_INPUT_2, LOW);
    digitalWrite(MOTOR_INPUT_3, LOW);
    digitalWrite(MOTOR_INPUT_4, LOW);
}

void setMotors(int sumWeights, int counter){
  Serial.print("sumWeights: ");
  Serial.println(sumWeights);
  if(sumWeights>0){
    go_right();
    //delay(100*sumWeights);
    delay(100);
    stand_still();
  }
  else if(sumWeights<0){
    go_left();
    //delay(100*abs(sumWeights));
    delay(100);
    stand_still();
  }
  else{
    if(counter!=0 && counter!=5){
      go_forward();
      delay(200);
    }

    stand_still();
  }
}

void setup() {
  Serial.begin(115200);

  for(int i=0; i<NUM_SENSORS; ++i){
    pinMode(sensorPins[i], INPUT); 
  }

  pinMode(MOTOR_INPUT_1, OUTPUT);
  pinMode(MOTOR_INPUT_2, OUTPUT);
  pinMode(MOTOR_INPUT_3, OUTPUT);
  pinMode(MOTOR_INPUT_4, OUTPUT);

  pinMode(TRIGGER_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
}

void moveCar(){
  int numerator = 0; 
  int counter = 0;
  for (int i=0; i<NUM_SENSORS; ++i){
    int sensorVal = digitalRead(sensorPins[i]);
    
    if(sensorVal == LOW) {  
      numerator += sensorWeights[i];
      counter++;
    }
  }
  
  setMotors(numerator, counter);
  delay(50); 
}

void loop(){
  moveCar();
}
