#include "controls.h"
#include "define.h"
#include <Arduino.h>

int state;

void set_state(State x){
    state = x;
}

int get_state(){
    return state;
}

void setup_controls(){
    // Setup dos motores
    pinMode(MOTOR_INPUT_1, OUTPUT);
    pinMode(MOTOR_INPUT_2, OUTPUT);
    pinMode(MOTOR_INPUT_3, OUTPUT);
    pinMode(MOTOR_INPUT_4, OUTPUT);

    // Setup dos sensores
    pinMode(SIGNAL_R, INPUT);
    pinMode(SIGNAL_MR, INPUT);
    pinMode(SIGNAL_M, INPUT);
    pinMode(SIGNAL_ML, INPUT);
    pinMode(SIGNAL_L, INPUT);

    // Setup do sensor ultrassonico
    pinMode(TRIGGER_PIN, OUTPUT);
    pinMode(ECHO_PIN, INPUT);

    // variaveis
    //state = PARADO;
    state = TRILHO;

}

void set_direction(direction x){
    switch(x){
        case STOP:
            stand_still();
            break;
        case LEFT:
            go_left();
            break;
        case RIGHT:
            go_right();
            break;
        case FORWARD:
            go_forward();
            break;
        default:
            stand_still();
            break;
    }
}

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

float get_distance(){

    long duration;
    float distance;

    digitalWrite(TRIGGER_PIN, LOW);
    delayMicroseconds(2);
    digitalWrite(TRIGGER_PIN, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIGGER_PIN, LOW);

    duration = pulseIn(ECHO_PIN, HIGH);
    distance = duration * SOUND_SPEED / 2;
    
    #if DEBUG
    Serial.print(millis()); // Imprime o valor de millis() corretamente
    Serial.print(" - ");
    Serial.print("Duração (us): ");
    Serial.println(duration);
    Serial.print(millis()); // Imprime novamente millis() corretamente
    Serial.print(" - ");
    Serial.print("Distância (cm): ");
    Serial.println(distance);
    #endif

    return distance;
}
