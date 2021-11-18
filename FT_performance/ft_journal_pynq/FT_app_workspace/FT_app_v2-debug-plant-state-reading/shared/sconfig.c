#include "sconfig.h"

// CONTROL SYSTEM PARAMETERS
#define N  5                    // System dimension: augmented system

float initial_condition_state[N-1][1]           = {{0.0f}, {0.0f}, {0.0f}, {0.0f}}; // system states initial conditions
float initial_condition_control_input[1][1]     = {{0.0f}}; // control input initial conditions

// DEBUGGING INFO
int DEBUG_INFO  =  0; // Measure data: states
int TIMING_INFO =  0; // Measure sensing|computing|actuating task execution time

int DEBUG_INFO_PLANT  = 0; // Measure data from plant: states
int TIMING_INFO_PLANT =  0; // Measure plant task execution time
