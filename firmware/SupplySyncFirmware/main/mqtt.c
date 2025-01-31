#include "mqtt.h"

#include "config.h"

#include "esp_log.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_system.h" // Adicione esta linha para incluir a função esp_read_mac
#include "mqtt_client.h"
#include "esp_event.h"
#include "freertos/event_groups.h"
#include "nvs_flash.h"

static const char *TAG = "MQTT_EXAMPLE";
esp_mqtt_client_handle_t client;

char topico_telemetria[50];
char topico_comando[50];

static void mqtt_event_handler(void *handler_args, esp_event_base_t base, int32_t event_id, void *event_data) {
    ESP_LOGI(TAG, "MQTT Event ID: %d", (int) event_id);
    esp_mqtt_event_handle_t event = event_data;

    switch ((esp_mqtt_event_id_t)event_id) {
        case MQTT_EVENT_CONNECTED:
            ESP_LOGI(TAG, "Conectado ao broker MQTT!");
            esp_mqtt_client_subscribe(client, "topico/teste", 0);
            char mensagem[50];
            sprintf(mensagem, "%s conectado", ID_CARRO); // Exemplo de uso do
            esp_mqtt_client_publish(client, topico_telemetria, mensagem, 0, 1, 0);
            break;

        case MQTT_EVENT_DISCONNECTED:
            ESP_LOGW(TAG, "Desconectado do broker MQTT!");
            break;

        case MQTT_EVENT_SUBSCRIBED:
            ESP_LOGI(TAG, "Inscrito no tópico: %d", (int) event->msg_id);
            break;

        case MQTT_EVENT_UNSUBSCRIBED:
            ESP_LOGI(TAG, "Desinscrito do tópico: %d", (int) event->msg_id);
            break;

        case MQTT_EVENT_PUBLISHED:
            ESP_LOGI(TAG, "Mensagem publicada com ID: %d", (int) event->msg_id);
            break;

        case MQTT_EVENT_DATA:
            ESP_LOGI(TAG, "Mensagem recebida no tópico: %.*s", event->topic_len, event->topic);
            ESP_LOGI(TAG, "Dados: %.*s", event->data_len, event->data);
            break;

        default:
            ESP_LOGW(TAG, "Outro evento MQTT recebido: %d", (int) event_id);
            break;
    }
}

void mqtt_init() {

    sprintf(topico_telemetria, "drones/%s/telemetria", ID_CARRO);
    sprintf(topico_comando, "drones/%s/comando", ID_CARRO);

    esp_mqtt_client_config_t mqtt_cfg = {
            .broker.address.uri = "mqtt://srv689391.hstgr.cloud",
            .broker.address.port = 1883,
            .credentials.username = NULL,  
            .credentials.authentication.password = NULL,
            .session.last_will.topic = "carro1/telemetria",
            .session.last_will.msg = "ESP32 desconectado!",
            .session.last_will.qos = 1,
            .session.last_will.retain = false
    };

    client = esp_mqtt_client_init(&mqtt_cfg);
    esp_mqtt_client_register_event(client, ESP_EVENT_ANY_ID, mqtt_event_handler, NULL);
    esp_mqtt_client_start(client);
}
