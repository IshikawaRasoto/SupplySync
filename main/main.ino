#include "define.h"
#include "tasks.h"
#include "controls.h"

/*

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

void setup() {
  Serial.begin(115200);
  setup_mqtt();
  setup_controls();
  pinMode(2, OUTPUT);
  create_tasks();
  
}

void loop(){
}
