#ifndef CONTROLS_H
#define CONTROLS_H

// Macros Movimentação

enum direction {
    STOP = 0,
    LEFT = 1,
    RIGHT = 2,
    FORWARD = 3,
    TURN = 4
};

// Macros estados de movimentação

enum State {
    TRILHO = 0,
    CRUZAMENTO = 1,
    PARADO = 2
};

// Setup
void setup_controls();

// Controles

void set_direction(direction x);

void turn();
void go_forward();
void go_left();
void go_right();
void stand_still();

// Sensores

float get_distance();

// setters e getters

void set_state(State x);
int get_state();

#endif //CONTROLS_H
