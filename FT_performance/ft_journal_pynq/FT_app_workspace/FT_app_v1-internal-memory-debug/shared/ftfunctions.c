#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <xil_printf.h>

// Functions to support the Fault-Tolerance Control Application
// mode()      : calculation of modes
// lc()        : location counter calculation (to identify my current slot)
// efc()       : error-free counter calculation (to do the computation of the counters when there are no errors)
// sensing()   : update sensed values
// computing() : calculate control input according to the mode and controllers per mode
// actuating() : update actuation value and actuate according to the FT scheme

/* power */
int power(int base, unsigned int exp) {
    int i, result = 1;
    for (i = 0; i < exp; i++)
        result *= base;
    return result;
 }


/* error_sum() */
int array_sum(int input_array[], int mode){
  int i, sum = 0;

  for (i = (power(2,SYSTEMS) - power(2,mode)); i < power(2,SYSTEMS); i++){
    sum = sum + input_array[i];
  }

  return sum;
}


/* mode() */
int mode(int mode_old, int error_array[], int sw_sequence[], int ef_counter[]) {
	// algorithm
	int i = 1;
	int m = 1;

	if (mode_old < SYSTEMS){
		for(i = 1; i <= SYSTEMS; i++){

			if( mode_old == i ){
				if( array_sum(error_array, i) >= power(2,i)-1 ){
					if( ef_counter[i-1] >= sw_sequence[i-1] ){
						m = mode_old + 1;
					}
					else{
						m = mode_old;
					}
				}
				else{
					if( ef_counter[i-1] >= sw_sequence[i-1] ){
						if (mode_old > 1){
							m = mode_old - 1;
						}
						else{
							m = mode_old;
						}
					}
					else{
						m = mode_old;
					}
				}
			}
		}
	}
	else{
		for(i = 1; i <= SYSTEMS; i++){
			if( mode_old == i ){
				if( ef_counter[i-1] >= sw_sequence[i-1] ){
					m = mode_old - 1;
				}
				else{
					m = mode_old;
				}
			}
		}
	}


	//mk_mon_debug_info( m );
	return m;
}


/* lc() */
int lc(int current_mode, int old_mode, int lc_old){

  int location_counter = 0;
  //location_counter = lc_old;

  if ( lc_old >= power(2, old_mode) ){
    location_counter = 1;
  }
  else{
    if( lc_old >= power(2, current_mode) ){
      location_counter = 1;
    }
    else{
      location_counter = lc_old + 1;
    }
  }

  return location_counter;
}


/* efc() */
void efc(int error_array[], int current_mode, int location_counter, int efc_old[], int error_free_counter[]){

  int i = 1;

  // updating error_free_counter variable
  for(i = 1; i <= SYSTEMS; i++){
    error_free_counter[i-1] = efc_old[i-1];
  }

	// efc algorithm
	if ( location_counter >= power(2, current_mode) ){

		for(i = 1; i <= SYSTEMS; i++){
			if ( i != current_mode ){
				error_free_counter[i-1] = 0;
			}
			else{
				if( array_sum(error_array, i) < power(2, i)-1 ){
					error_free_counter[i-1] = error_free_counter[i-1] + 1;
				}
				else{
					error_free_counter[i-1] = 0;
					/*
					if(error_free_counter[i-1] == efc_old[i-1]){
						error_free_counter[i-1] = 0;
					}
					else{
						error_free_counter[i-1] = error_free_counter[i-1];
					}
					*/
				}
			}
		}
	}
	else{
		for(i = 1; i <= SYSTEMS; i++){
			if( i != current_mode ){
				error_free_counter[i-1] = 0;
			}
			else{
				error_free_counter[i-1] = error_free_counter[i-1];
			}
		}
	}

}


/* sensing() */
void sensing(int location_counter, int old_sensed_data[N-1][1], int plant_states[N-1][1], int sensed_data[N-1][1], float sensing_instant[1][1]){

  int i = 0;

  //mk_mon_debug_info( location_counter );

  // variable with old sensed_data
  for(i=0; i<(N-1); i++){
    sensed_data[i][0] = old_sensed_data[i][0];
  }

  if ( location_counter == 1 ){
    sensing_instant[0][0] = 1.0f;
  	for(i=0; i<(N-1); i++){
  		sensed_data[i][0] = plant_states[i][0];
  	}
  }
  else{
    sensing_instant[0][0] = 0.0f;
  	for(i=0; i<(N-1); i++){
  		sensed_data[i][0] = sensed_data[i][0];
  	}
  }

}


/* actuating() */
void actuating(int error_array[], int current_mode, int location_counter, float control_input[1][1], float old_actuation_signal[1][1], float actuation_signal[1][1], float actuation_instant[1][1]){

  // algorithm
  if( location_counter == power(2,current_mode) ){
    actuation_instant[0][0] = 1.0f;
    if( array_sum(error_array, current_mode) >= power(2,current_mode)-1 ){
      actuation_signal[0][0] = old_actuation_signal[0][0];
    }
    else{
      actuation_signal[0][0] = control_input[0][0];
    }
  }
  else{
    actuation_instant[0][0] = 0.0f;
    actuation_signal[0][0] = old_actuation_signal[0][0];
  }

}
