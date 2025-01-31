#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <inttypes.h>  // Adicione essa linha no topo do código

#include "esp_log.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_system.h" // Adicione esta linha para incluir a função esp_read_mac
#include "mqtt_client.h"
#include "esp_event.h"
#include "freertos/event_groups.h"
#include "nvs_flash.h"

// bibliotecas locais
#include "wifi.h"
#include "mqtt.h"


void app_main(void)
{
    ESP_LOGI("Config", "Initilizing Drone");
    //uint8_t mac[6];
    //esp_read_mac(mac, ESP_IF_WIFI_STA);
    //ESP_LOGI("Config", "MAC Address: %02x:%02x:%02x:%02x:%02x:%02x", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);

    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ESP_ERROR_CHECK(nvs_flash_init());
    }

    ESP_LOGI("Config", "Inicializando Wi-Fi...");
    wifi_init_sta();

    ESP_LOGI("Config", "Inicializando MQTT...");
    mqtt_init();

    while(1){
        ESP_LOGI("main loop", "Hello world!");
        vTaskDelay(10000 / portTICK_PERIOD_MS);
    }
}