#include <stdio.h>
#include <stdlib.h>
#include <memmap.h>
#include <stdint.h>
#include <xil_printf.h>
#include "../shared/ws_errors.h" // to simulate faults
#include "../shared/ws_reference.h" // to simulate faults
// #include <inttypes.h>

// Sensing-Computing-Actuating tile
#define N 5 // System
#define HM 500000 // hm = 5ms -> hi = 2^{i+1}hm
#define DELAY 20000 // actuation_dealy 200us
#define SYSTEMS  3 // total amount of switching systems: C1, C2, C3
#define ERROR_ARRAY_SIZE 16   // 2^(SYSTEMS+1) 1024 for 9 systems
#define FLOAT_TO_INT 100000 // float2int constant
#define LOOPS 1200 // control loops
#define DEBUG_VARIABLES 5 // variables that will be saved to external memory

/* Function for matrix multiplication */
void multiply_matrix( int m,  int n,  int p,  int q,  float mA[m][n],  float mB[p][q], float mR[m][q])
{
	int i = 0;
	int j = 0;
	int k = 0;
	float sum = 0.0;

	for ( i=0; i<m; i++ ){
		for ( j=0; j<q; j++ ){
			for ( k=0; k<p; k++ ){
				sum = sum + ( mA[i][k] * mB[k][j] );
			}
			mR[i][j] = sum;
			sum = 0.0; // --> restart the addition counter for a column change
		}
	}
}

/* Function for matrix addition */
void add_matrix( int m,  int n,  float mA[m][n],  float mB[m][n], float mR[m][n])
{
	int i = 0;
	int j = 0;

	for ( i=0; i<m; i++ ){
		for ( j=0; j<n; j++ ){
			mR[i][j] = mA[i][j] + mB[i][j];
		}
	}
}



// Functions to support the Fault-Tolerance Control Application
// mode()      : calculation of modes
// lc()        : location counter calculation (to identify my current slot)
// efc()       : error-free counter calculation (to do the computation of the counters when there are no errors)
// sensing()   : update sensed values
// computing() : calculate control input according to the mode and controllers per mode
// actuating() : update actuation value and actuate according to the FT scheme

/* power */
int power(int base, int exp) {
	int i, result = 1;
	for (i = 0; i < exp; i++)
		result *= base;
	return result;
}

/* error_sum() */
int array_sum(int input_array[], int mode){
	int i, sum = 0;

	for (i = (power(2,SYSTEMS+1) - power(2,mode+1)); i < power(2,SYSTEMS+1); i++){
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
				if( array_sum(error_array, i) >= power(2,i+1)-1 ){
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

	return m;
}

/* lc() */
int lc(int current_mode, int old_mode, int lc_old){

	int location_counter = 0;

	if ( lc_old >= power(2, old_mode+1) ){
		location_counter = 1;
	}
	else{
		if( lc_old >= power(2, current_mode+1) ){
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
	if ( location_counter >= power(2, current_mode+1) ){

		for(i = 1; i <= SYSTEMS; i++){
			if ( i != current_mode ){
				error_free_counter[i-1] = 0;
			}
			else{
				if( array_sum(error_array, i) < power(2, i+1)-1 ){
					error_free_counter[i-1] = error_free_counter[i-1] + 1;
				}
				else{
					error_free_counter[i-1] = 0;
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
int sensing(int location_counter, float plant_states[N-1][1], float sensed_data[N-1][1], float old_actuation_signal[1][1], float augmented_state[N][1], float old_augmented_state[N][1]){

	int i = 0;
	int sensing_instant = 0;

	if ( location_counter == 1 ){
		sensing_instant = 1;

		sensed_data[0][0] = plant_states[0][0];
		sensed_data[1][0] = plant_states[1][0];
		sensed_data[2][0] = plant_states[2][0];
		sensed_data[3][0] = plant_states[3][0];

		augmented_state[0][0] = sensed_data[0][0];
		augmented_state[1][0] = sensed_data[1][0];
		augmented_state[2][0] = sensed_data[2][0];
		augmented_state[3][0] = sensed_data[3][0];
		augmented_state[4][0] = old_actuation_signal[i][0];
	}
	else{
		sensing_instant = 0;
		
		augmented_state[0][0] = old_augmented_state[0][0];
		augmented_state[1][0] = old_augmented_state[1][0];
		augmented_state[2][0] = old_augmented_state[2][0];
		augmented_state[3][0] = old_augmented_state[3][0];
		augmented_state[4][0] = old_augmented_state[4][0];			
	}

	return sensing_instant;

}

/* actuating() */
int actuating(int error_array[], int current_mode, int location_counter, float control_input[1][1], float old_actuation_signal[1][1], float actuation_signal[1][1]){

	int actuation_instant = 0;

  // algorithm
	if( location_counter == power(2,current_mode+1) ){
		actuation_instant = 1;

		if( array_sum(error_array, current_mode) >= power(2,current_mode+1)-1 ){
			actuation_signal[0][0] = old_actuation_signal[0][0];
		}
		else{
			actuation_signal[0][0] = control_input[0][0];
		}

	}
	else{
		actuation_instant = 0;

		actuation_signal[0][0] = old_actuation_signal[0][0];
	}

	return actuation_instant;

}






// -----------------------------------------------------------------------------
int main ( void )
{

  // Communication variables ---------------------------------------------------
  // til0 <-> tile2
	volatile float *shared02 = (float *)(tile0_comm2);

  //define a value that points to the timer ------------------------------------
	volatile uint64_t *timer = 0x00FC0000;
	uint64_t t_iter = *timer;
	uint64_t t_iter_delay = *timer;

	uint64_t t1 = *timer;
	uint64_t t2 = *timer;
	uint64_t t3 = *timer;
	uint64_t tdiff21 = *timer;
	uint64_t tdiff31 = *timer;


  // Controllers variables -----------------------------------------------------
	float K1[1][N]={{-29.84841e-003f,  -29.84841e-003f,  -59.69633e-006f,  -59.69633e-006f,  -903.1552e-003f}};
	float K2[1][N]={{-13.61762e-003f,  -13.61762e-003f,  -27.23523e-006f,  -27.23523e-006f,  -955.8358e-003f}};
	float K3[1][N]={{-6.523068e-003f,  -6.523068e-003f,  -13.04614e-006f,  -13.04614e-006f,  -978.4769e-003f}};
	float K4[1][N]={{-3.196274e-003f,  -3.196274e-003f,  -6.392549e-006f,  -6.392549e-006f,  -989.5717e-003f}};
	float K5[1][N]={{-1.582239e-003f,  -1.582239e-003f,  -3.164478e-006f,  -3.164478e-006f,  -994.8945e-003f}};
	float K6[1][N]={{-787.1334e-006f,  -787.1334e-006f,  -1.574267e-006f,  -1.574267e-006f,  -997.4230e-003f}};
	float K7[1][N]={{-392.5991e-006f,  -392.5991e-006f,  -785.1981e-009f,  -785.1981e-009f,  -998.7310e-003f}};
	float K8[1][N]={{-196.0544e-006f,  -196.0544e-006f,  -392.1088e-009f,  -392.1088e-009f,  -999.3613e-003f}};
	float K9[1][N]={{-97.96646e-006f,  -97.96646e-006f,  -195.9329e-009f,  -195.9329e-009f,  -999.6804e-003f}};

	float F1[1][1]={{59.69682e-003f}};
	float F2[1][1]={{27.23523e-003f}};
	float F3[1][1]={{13.04614e-003f}};
	float F4[1][1]={{6.392549e-003f}};
	float F5[1][1]={{3.164478e-003f}};
	float F6[1][1]={{1.574267e-003f}};
	float F7[1][1]={{785.1981e-006f}};
	float F8[1][1]={{392.1088e-006f}};
	float F9[1][1]={{195.9329e-006f}};


	float K[1][N]={{0.0f,0.0f,0.0f,0.0f,0.0f}};
	float F[1][1]={{0.0f}};


  // Sensing variable ----------------------------------------------------------
	float state[N-1][1];
	state[0][0] = 0.0f;
	state[1][0] = 0.0f;
	state[2][0] = 0.0f;
	state[3][0] = 0.0f;

  	// Computing variable --------------------------------------------------------
	float augmented_state[N][1];
	augmented_state[0][0] = 0.0f;
	augmented_state[1][0] = 0.0f;
	augmented_state[2][0] = 0.0f;
	augmented_state[3][0] = 0.0f;
	augmented_state[4][0] = 0.0f;

	float test_old_augmented_state[N][1];
	test_old_augmented_state[0][0] = 0.0f;
	test_old_augmented_state[1][0] = 0.0f;
	test_old_augmented_state[2][0] = 0.0f;
	test_old_augmented_state[3][0] = 0.0f;
	test_old_augmented_state[4][0] = 0.0f;

	float new_control_input[1][1];
	new_control_input[0][0] = 0.0f;
	*(shared02+4) = 0.0f; // initializing shared mem. location with 0

	float new_control_inputA[1][1] = {{0.0f}};
	float new_control_inputB[1][1] = {{0.0f}};

  // Reference variable --------------------------------------------------------
	float reference[1][1] = {{ 0.0f }};

  // fault-tolerance meachnism variables ---------------------------------------
	int input_error_array[ERROR_ARRAY_SIZE] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  	int switching_sequence[SYSTEMS] = {1, 1, 2}; // C1x1, C2x1, C3x3

  // Input sequences variables -------------------------------------------------
	int k_loop = 0; // pattern length counter
	int i = 0;
	int test_m = 1;
	int test_mold = 1;
	int test_lc = 0;
	int test_lcold = 0;
	int test_efc[SYSTEMS]    = {0,0,0};
	int test_oldefc[SYSTEMS] = {0,0,0};

	int sensingI = 0;
	int actuationI = 0;
	float test_sensing[N-1][1] = {{0.0f}, {0.0f}, {0.0f}, {0.0f}};
	float test_actuation[1][1] = {{0.0f}};
	float test_oldactuation[1][1] = {{0.0f}};

	// debugging arrays ----------------------------------------------------------
	volatile uint32_t *shared01_ext_uint32 = (uint32_t *)(tile0_comm1);
	volatile int *shared01_ext_int = (int *)(tile0_comm1); // external memory
	//----------------------------------------------------------------------------


	// initialize
	for(i=0; i < (LOOPS*DEBUG_VARIABLES); i++){
		*(shared01_ext_uint32 + i) = 0;
	};

	// xil_printf("d1\n");

  // synchronization with tile 2 -----------------------------------------------
	volatile int init_comm = 0;
	while(init_comm == 0){
		init_comm = *(shared02+10);
	};
  // ---------------------------------------------------------------------------


  // Control loops -------------------------------------------------------------
	t_iter = *timer;
	t_iter_delay = *timer;

  // for(int k=0; k < ws_reference_len; k++){
	for(k_loop=0; k_loop < LOOPS; k_loop++){

		t1=*timer;

   	// UPDATING THE ERROR VECTOR -----------------------------------------------
		for(i=0; i<ERROR_ARRAY_SIZE; i++){
			if (i < ERROR_ARRAY_SIZE-1){
				input_error_array[i] = input_error_array[i+1];
			}
			else if (i == ERROR_ARRAY_SIZE-1){
				input_error_array[i] = ws_errors[k_loop];
			}
			else{
				xil_printf("ERROR: Incorrect input error array access!\n");
			}
		};

    // MODE --------------------------------------------------------------------
		test_m = mode(test_mold, input_error_array, switching_sequence, test_efc);
		// m_array[k_loop]=test_m;

		// LOCAL COUNTER -----------------------------------------------------------
		test_lc = lc(test_m, test_mold, test_lcold);

		// ERROR FREE COUNTER ------------------------------------------------------
		efc(input_error_array, test_m, test_lc, test_oldefc, test_efc);

    // SENSISNG ----------------------------------------------------------------
    // RD plant state
		state[0][0] = *(shared02+0);
		state[1][0] = *(shared02+1);
		state[2][0] = *(shared02+2);
		state[3][0] = *(shared02+3);

    // outputs | test_sensing [with states] and sensingI [sensing instant]
		sensingI = sensing(test_lc, state, test_sensing, test_oldactuation, augmented_state, test_old_augmented_state);

    // COMPUTING ---------------------------------------------------------------
		reference[0][0] =  ws_reference[k_loop];

		// COMPUTING TASK: Find the new control input ------------------------------
		if ( test_m == 1 ){
			for(i=0; i<N; i++){ K[0][i] = K1[0][i]; }; F[0][0] = F1[0][0];
		}else if ( test_m == 2 ){
			for(i=0; i<N; i++){ K[0][i] = K2[0][i]; }; F[0][0] = F2[0][0];
		}else if ( test_m == 3 ){
			for(i=0; i<N; i++){ K[0][i] = K3[0][i]; }; F[0][0] = F3[0][0];
		}else if ( test_m == 4 ){
			for(i=0; i<N; i++){ K[0][i] = K4[0][i]; }; F[0][0] = F4[0][0];
		}else if ( test_m == 5 ){
			for(i=0; i<N; i++){ K[0][i] = K5[0][i]; }; F[0][0] = F5[0][0];
		}else if ( test_m == 6 ){
			for(i=0; i<N; i++){ K[0][i] = K6[0][i]; }; F[0][0] = F6[0][0];
		}else if ( test_m == 7 ){
			for(i=0; i<N; i++){ K[0][i] = K7[0][i]; }; F[0][0] = F7[0][0];
		}else if ( test_m == 8 ){
			for(i=0; i<N; i++){ K[0][i] = K8[0][i]; }; F[0][0] = F8[0][0];
		}else if ( test_m == 9 ){
			for(i=0; i<N; i++){ K[0][i] = K9[0][i]; }; F[0][0] = F9[0][0];
		}else{
			xil_printf("WRONG MODE!\n");
		}

		multiply_matrix(1, N, N, 1, K, augmented_state, new_control_inputA);
		multiply_matrix(1, 1, 1, 1, F, reference, new_control_inputB);
		add_matrix(1, 1, new_control_inputA, new_control_inputB, new_control_input);

    // ACTUATING ---------------------------------------------------------------
		actuationI = actuating(input_error_array, test_m, test_lc, new_control_input, test_oldactuation, test_actuation);

		t_iter_delay = t_iter + DELAY;
		while(*timer<t_iter_delay);

		// WR control input to external memory -------------------------------------
		if(k_loop==0){
			*(shared02+4) = 0.0f;
		}
		else{
			*(shared02+4) = test_actuation[0][0];
		}

		t2=*timer;
		tdiff21=t2-t1;


    // OLD VARIABLES UPDATE ----------------------------------------------------
		test_mold  = test_m;
		test_lcold = test_lc;

		for(i=0; i<SYSTEMS; i++){
			test_oldefc[i] = test_efc[i];
		}

		test_oldactuation[0][0] = test_actuation[0][0];

		for(i=0; i<N; i++){
			test_old_augmented_state[i][0] = augmented_state[i][0];
		}


		tdiff31=t1-t3;
		t3 = t1;


		// debugging ---------------------------------------------------------------
		*(shared01_ext_int + (k_loop +0*LOOPS)) = k_loop;

		*(shared01_ext_int + (k_loop +1*LOOPS)) = (int)(augmented_state[0][0]*FLOAT_TO_INT);
		*(shared01_ext_int + (k_loop +2*LOOPS)) = (int)(augmented_state[1][0]*FLOAT_TO_INT);
		*(shared01_ext_int + (k_loop +3*LOOPS)) = (int)(augmented_state[2][0]*FLOAT_TO_INT);
		*(shared01_ext_int + (k_loop +4*LOOPS)) = (int)(augmented_state[3][0]*FLOAT_TO_INT);
		// -------------------------------------------------------------------------


		// asm("sleep");
		t_iter = t_iter + HM;
		while(*timer<t_iter);
	}


	// loop for debuggin ---------------------------------------------------------
	int k_temp = 0;
	int s0_temp, s1_temp, s2_temp, s3_temp = 0;

	xil_printf("k, s0, s1, s2, s3\n");

	for(k_loop=0; k_loop < LOOPS; k_loop++){

		k_temp = *(shared01_ext_int + (k_loop +0*LOOPS));

		s0_temp = *(shared01_ext_int + (k_loop +1*LOOPS));
		s1_temp = *(shared01_ext_int + (k_loop +2*LOOPS));
		s2_temp = *(shared01_ext_int + (k_loop +3*LOOPS));
		s3_temp = *(shared01_ext_int + (k_loop +4*LOOPS));

		xil_printf("%d, %d, %d, %d, %d\n", k_temp, s0_temp, s1_temp, s2_temp, s3_temp);

	}


	return 0;
}
