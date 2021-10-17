#ifndef SCONFIG_H_
#define SCONFIG_H_

// CONTROL SYSTEM PARAMETERS
#define N  5                    // System dimension: augmented system

extern float initial_condition_state[N-1][1];
extern float initial_condition_control_input[1][1];

// DEBUGGING INFO
extern int DEBUG_INFO;
extern int TIMING_INFO;

extern int DEBUG_INFO_PLANT;
extern int TIMING_INFO_PLANT;

#endif /* SCONFIG_H_ */
