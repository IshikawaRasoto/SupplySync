#ifndef TASKS_H
#define TASKS_H

void create_tasks();
void setup_mqtt();

// tasks

void toggleLED(void * parameter);
void read_sensors(void * parameter);
void verify_mqtt(void * parameter);
void battery_telemetry(void * parameter);

#endif //TASKS_H