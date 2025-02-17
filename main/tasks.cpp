#include "tasks.h"
#include "define.h"
#include <Arduino.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include <Wire.h>
#include <Adafruit_ADS1X15.h>

#include "controls.h"

WiFiClient espClient;
PubSubClient client(espClient);

Adafruit_ADS1115 ads;

TaskHandle_t task1Handle_led = NULL;
TaskHandle_t task2Handle_sensors = NULL;
TaskHandle_t task3Handle_mqtt_verify = NULL;

direction cruzamento_direction = STOP;

unsigned long time_cruzamento = 0;

int counter_offtrack = 0;

bool resposta_cruzamento = false;

void create_tasks(){

    ads.begin();
  
    xTaskCreate(
        toggleLED,    // Função a ser chamada
        "Toggle LED",   // Nome da tarefa
        1000,            // Tamanho (bytes)
        NULL,            // Parametro a ser passado
        1,               // Prioridade da Tarefa
        &task1Handle_led             // Task handle
    );

    xTaskCreate(
        read_sensors,    // Função a ser chamada
        "Read Sensors",   // Nome da tarefa
        2048,            // Tamanho (bytes)
        NULL,            // Parametro a ser passado
        3,               // Prioridade da Tarefa
        &task2Handle_sensors             // Task handle
    );

    xTaskCreate(
        verify_mqtt,    // Função a ser chamada
        "Verify MQTT",   // Nome da tarefa
        2048,            // Tamanho (bytes)
        NULL,            // Parametro a ser passado
        2,               // Prioridade da Tarefa
        &task3Handle_mqtt_verify             // Task handle
    );

    xTaskCreate(
        battery_telemetry,    // Função a ser chamada
        "Battery Telemetry",   // Nome da tarefa
        2048,            // Tamanho (bytes)
        NULL,            // Parametro a ser passado
        2,               // Prioridade da Tarefa
        NULL             // Task handle
    );
    
}

void mqtt_callback(char* topic, byte* payload, unsigned int length) {

    String topico = topic;
    String payload_str = "";
    for (int i = 0; i < length; i++) {
        payload_str += (char)payload[i];
    }

    if(topico == "cars/" + String(CARRO_ID) + "/comandos"){
        if(payload_str == "P"){
            set_state(PARADO);
            cruzamento_direction = STOP;
            resposta_cruzamento = true;
        }
        else if(payload_str == "A"){
            set_state(TRILHO);
        }
        else if(payload_str == "R"){
            cruzamento_direction = RIGHT;
            resposta_cruzamento = true;
            time_cruzamento = millis();

        }
        else if(payload_str == "L"){
            cruzamento_direction = LEFT;
            resposta_cruzamento = true;
            time_cruzamento = millis();

        }
        else if(payload_str == "S"){
            cruzamento_direction = FORWARD;
            resposta_cruzamento = true;
            time_cruzamento = millis();

        }
        else if(payload_str == "B"){
            cruzamento_direction = TURN;
            resposta_cruzamento = true;
            time_cruzamento = millis();
        }
    }

}

void setup_wifi() {
    Serial.print("Conectando ao WiFi: ");
    Serial.println(WIFI_SSID);
    WiFi.begin(WIFI_SSID, WIFI_PASS);
    
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.print(".");
        digitalWrite(2, HIGH);
    }
    Serial.println("\nWiFi conectado!");
}

void reconnect_mqtt() {
    while (!client.connected()) {
        Serial.print("Tentando conectar ao broker MQTT...");
        if (client.connect(CARRO_ID)) {
            Serial.println("Conectado!");

            String topico_comandos = "cars/" + String(CARRO_ID) + "/comandos";
            client.subscribe(topico_comandos.c_str());
        } else {
            Serial.print("Falha, rc=");
            Serial.print(client.state());
            Serial.println(" Tentando novamente em 5 segundos...");
            delay(5000);
        }
    }
}

void setup_mqtt(){
    // Setup MQTT

    setup_wifi();

    client.setServer(MQTT_BROKER, MQTT_PORT);
    client.setCallback(mqtt_callback);
    reconnect_mqtt();
}

void verify_mqtt(void * parameter){
    for(;;){
        if (!client.connected()) {
            reconnect_mqtt();
        }
        client.loop();

        vTaskDelay(250/portTICK_PERIOD_MS);
    }
}

void battery_telemetry(void * parameter){
    for(;;){
        uint32_t soma = 0;
        for(int i = 0; i < 10; i++){
          soma += ads.readADC_SingleEnded(0);
          vTaskDelay(25/portTICK_PERIOD_MS);
        }

        uint32_t leitura = soma/10;

        String topico_telemetria = "cars/" + String(CARRO_ID) + "/telemetria";
        String s_leitura = String(leitura);
        client.publish(topico_telemetria.c_str(), s_leitura.c_str());

        vTaskDelay(5000/portTICK_PERIOD_MS);
    }
}

bool led = false;

void toggleLED(void * parameter){
  for(;;){
    led = !led;
    if(led)
      digitalWrite(2, HIGH);
    else
      digitalWrite(2, LOW);
  
   vTaskDelay(500/portTICK_PERIOD_MS);
  }
}

void set_direction_trilho(bool l, bool ml, bool m, bool mr, bool r){

    uint8_t soma_sensores = 0;
    soma_sensores += !l ? 1 : 0;
    soma_sensores += !ml ? 1 : 0;
    soma_sensores += !m ? 1 : 0;
    soma_sensores += !mr ? 1 : 0;
    soma_sensores += !r ? 1 : 0;

    if (soma_sensores >= 4 && (millis() - time_cruzamento) > 1500 && get_state() != PARADO){
        set_direction(STOP);
        counter_offtrack = 0;
        String topico_cruzamento = "cars/" + String(CARRO_ID) + "/cruzamento";
        client.publish(topico_cruzamento.c_str(), CARRO_ID);
        
        while(!resposta_cruzamento){
            vTaskDelay(50/portTICK_PERIOD_MS);
        }

        resposta_cruzamento = false;

        switch(cruzamento_direction){
            case STOP:
                set_direction(STOP);
                break;
            case RIGHT:
                set_direction(RIGHT);
                vTaskDelay(500/portTICK_PERIOD_MS);
                break;
            case LEFT:
                set_direction(LEFT);
                vTaskDelay(500/portTICK_PERIOD_MS);
                break;
            case FORWARD:
                set_direction(FORWARD);
                vTaskDelay(200/portTICK_PERIOD_MS);
                break;
            case TURN:
                set_direction(TURN);
                vTaskDelay(925/portTICK_PERIOD_MS);
                set_state(PARADO);
                break;
        }

        set_direction(STOP);
        // Comunicação HTTP, tem que esperar a resposta,
        // mudar estado para cruzamento    
    }
    else if(!mr || !r){
        set_direction(RIGHT);
        vTaskDelay(15/portTICK_PERIOD_MS);
        set_direction(STOP);
        counter_offtrack = 0;
    }
    else if(!ml || !l){
        set_direction(LEFT);
        vTaskDelay(15/portTICK_PERIOD_MS);
        set_direction(STOP);
        counter_offtrack = 0;
    }
    /*else if(r && mr && m && ml && l){
        counter_offtrack++;
        if(counter_offtrack > 2000){
            set_direction(STOP);
            counter_offtrack = 2001;
        }
    }*/
    else{
        set_direction(FORWARD);
        vTaskDelay(15/portTICK_PERIOD_MS);
        set_direction(STOP);
        counter_offtrack = 0;
    }
}

/*void set_direction_cruzamento(bool l, bool ml, bool m, bool mr, bool r){
    if(cruzamento_direction == STOP){
        set_direction(STOP);
        return; 
    }

    if (!r && !l && (millis() - time_cruzamento) > 750){
        time_cruzamento = millis();
        // Comunicação HTTP, tem que esperar a resposta,
        // mudar estado para cruzamento
        set_state(TRILHO);
    }

    if(!mr && cruzamento_direction == RIGHT){
        set_direction(RIGHT);
        vTaskDelay(20/portTICK_PERIOD_MS);
        set_direction(STOP);
        counter_offtrack = 0;
    }
    else if(!ml && cruzamento_direction == LEFT){
        set_direction(LEFT);
        vTaskDelay(20/portTICK_PERIOD_MS);
        set_direction(STOP);
        counter_offtrack = 0;
    }
    else if(r && mr && m && ml && l){
        counter_offtrack++;
        if(counter_offtrack > 50){
            set_direction(STOP);
            counter_offtrack = 51;
        }
    }
    else{
        set_direction(FORWARD);vTaskDelay(10/portTICK_PERIOD_MS);
        set_direction(STOP);
        vTaskDelay(20/portTICK_PERIOD_MS);
        set_direction(STOP);
        counter_offtrack = 0;
    }
    
}*/

void read_sensors(void * parameter){
  for(;;){
    #if DEBUG
    Serial.print(millis());
    Serial.print(" - ");
    Serial.println("Reading sensors...");
    #endif

    bool r = digitalRead(SIGNAL_R);
    bool mr = digitalRead(SIGNAL_MR);
    bool m = digitalRead(SIGNAL_M);
    bool ml = digitalRead(SIGNAL_ML);
    bool l = digitalRead(SIGNAL_L);

    #if DEBUG
        Serial.print(millis());
        Serial.print(" - ");
        Serial.print(l);
        Serial.print(",");
        Serial.print(ml);
        Serial.print(",");
        Serial.print(m);
        Serial.print(",");
        Serial.print(mr);
        Serial.print(",");
        Serial.println(r);
    #endif

    if(get_state() == TRILHO){
        set_direction_trilho(l, ml, m, mr, r);
    }
    else{
      set_direction(STOP);
    }

    vTaskDelay(5/portTICK_PERIOD_MS);
  }
}
