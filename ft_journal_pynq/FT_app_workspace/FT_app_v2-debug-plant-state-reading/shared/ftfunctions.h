#ifndef FTFUNCTIONS_H_
#define FTFUNCTIONS_H_

// Functions to support the Fault-Tolerance Control Application
// mode()      : calculation of modes
// lc()        : location counter calculation (to identify my current slot)
// efc()       : error-free counter calculation (to do the computation of the counters when there are no errors)
// sensing()   : update sensed values
// computing() : calculate control input according to the mode and controllers per mode
// actuating() : update actuation value and actuate according to the FT scheme

int power(int base, unsigned int exp); // power

int array_sum(int input_array[], int mode); // error_sum()

int mode(int mode_old, int error_array[], int sw_sequence[], int ef_counter[]); //mode()

int lc(int current_mode, int old_mode, int lc_old); // lc()

void efc(int error_array[], int current_mode, int location_counter, int efc_old[], int error_free_counter[]); // efc()

void sensing(int location_counter, int old_sensed_data[N-1][1], int plant_states[N-1][1], int sensed_data[N-1][1], float sensing_instant[1][1]); // sensing()

void actuating(int error_array[], int current_mode, int location_counter, float control_input[1][1], float old_actuation_signal[1][1], float actuation_signal[1][1], float actuation_instant[1][1]); // actuating()


#endif
