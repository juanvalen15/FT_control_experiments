#include <stdio.h>
#include <stdint.h>
#include <memmap.h>
#include <stdint.h>
#include <xil_printf.h>


#define N  5 // System
#define HP 20000 // hp = 200us
#define FLOAT_TO_INT 100000 // float2int constant factor
#define LOOPS 400 // control loops
#define DEBUG_VARIABLES 10 // variables that will be saved to external memory

/* Function for matrix multiplication */
void multiply_matrix_p( int m,  int n,  int p,  int q,  float mA[m][n],  float mB[p][q], float mR[m][q])
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
void add_matrix_p( int m,  int n,  float mA[m][n],  float mB[m][n], float mR[m][n])
{
	int i = 0;
	int j = 0;

	for ( i=0; i<m; i++ ){
		for ( j=0; j<n; j++ ){
			mR[i][j] = mA[i][j] + mB[i][j];
		}
	}
}

/* Set array values */
void set_matrix_p( int m,  int n, float mS[m][n],  float set_value)
{
	int i = 0;
	int j = 0;

	for ( i=0; i<m; i++ ){
		for ( j=0; j<n; j++ ){
			mS[i][j] =  set_value;
		}
	}
}


int main(void)
{

	// Communication variables ---------------------------------------------------
	// til0 <-> tile2
	volatile float *shared02 = (float *)(tile2_comm0);

	//define a value that points to the timer ------------------------------------
	volatile uint64_t *timer = 0x00FC0000;
	uint64_t t_iter = *timer;

	uint64_t t1 = *timer;
	uint64_t t2 = *timer;
	uint64_t tdiff21 = *timer;	

	// System Parameters ---------------------------------------------------------
	// float A[N-1][N-1] = {
	// 	{952.1801e-003f,   47.81994e-003f,   89.54654e-006f,   7.994606e-006f},
	// 	{47.81994e-003f,   952.1801e-003f,   7.994606e-006f,   89.54654e-006f},
	// 	{-887.7336e+000f,   887.7336e+000f,   787.1992e-003f,   164.0302e-003f},
	// 	{887.7336e+000f,  -887.7336e+000f,   164.0302e-003f,   787.1992e-003f}
	// };
	// float B[N-1][1] = {{4.643475e-003f}, {261.6827e-006f}, {89.31820e+000f}, {7.974220e+000f}};

	float A[N-1][N-1] = {
		{ 836.5372e-003f,   163.4628e-003f,   157.4491e-006f,   32.87610e-006f},
		{ 163.4628e-003f,   836.5372e-003f,   32.87610e-006f,   157.4491e-006f},
		{-1.356039e+003f,   1.356039e+003f,   574.1921e-003f,   330.6453e-003f},
		{ 1.356039e+003f,  -1.356039e+003f,   330.6453e-003f,   574.1921e-003f}
	};
	float B[N-1][1] = {{17.13930e-003f}, {2.161030e-003f}, {157.0476e+000f}, {32.79227e+000f}};


	float state[N-1][1];
	state[0][0] = 0.0f;
	state[1][0] = 0.0f;
	state[2][0] = 0.0f;
	state[3][0] = 0.0f;

	float new_control_input[1][1];
	new_control_input[0][0] = 0.0f;

	float state_next_iteration[N-1][1] = {{0.0f}, {0.0f}, {0.0f}, {0.0f}};
	float partialA[N-1][1];
	float partialB[N-1][1];


	int k_loop = 0;
	int i = 0;

	// debugging arrays ----------------------------------------------------------
	volatile uint32_t *shared21_ext_uint32 = (uint32_t *)(tile2_comm1);
	volatile int *shared21_ext_int = (int *)(tile2_comm1); // external memory
	//----------------------------------------------------------------------------

	// initialize
	for(i=0; i < (LOOPS*DEBUG_VARIABLES); i++){
		*(shared21_ext_int + i) = 0;
	};


	// synchronization with tile 0 -----------------------------------------------
	*(shared02+10) = 2;
  	// ---------------------------------------------------------------------------


	t_iter = *timer;

	// while(1){
	for(k_loop=0; k_loop < 10000; k_loop++){

		t1=*timer;

		// Read control input from shared memory -----------------------------------
		new_control_input[0][0] = *(shared02+4);

		// START: System dyanamics ------------------------------------------------
		// partialA and partialB declaration
		set_matrix_p(N-1, 1, partialA, 0.0f);
		set_matrix_p(N-1, 1, partialB, 0.0f);

		// Applying control input to system dynamics (plant)
		multiply_matrix_p(N-1, N-1, N-1, 1, A, state, partialA);
		multiply_matrix_p(N-1, 1, 1, 1, B, new_control_input, partialB);

		// state_next_iteration = partialA + partialB
		add_matrix_p(N-1, 1, partialA, partialB, state_next_iteration);

		// Update internal plant augmented state variable
		state[0][0] = state_next_iteration[0][0];
		state[1][0] = state_next_iteration[1][0];
		state[2][0] = state_next_iteration[2][0];
		state[3][0] = state_next_iteration[3][0];
		// END System dyanamics ----------------------------------------------------

		// Writing state to shared memory ------------------------------------------
		*(shared02+0) = state[0][0];
		*(shared02+1) = state[1][0];
		*(shared02+2) = state[2][0];
		*(shared02+3) = state[3][0];

		tdiff21=t1-t2;
		t2 = t1;

		// debugging ---------------------------------------------------------------
		if(k_loop < LOOPS){
			*(shared21_ext_int + (k_loop +0*LOOPS)) = k_loop;
			*(shared21_ext_uint32 + (k_loop +1*LOOPS)) = (uint32_t)tdiff21;
			*(shared21_ext_int + (k_loop +2*LOOPS)) = (int)(new_control_input[0][0]*FLOAT_TO_INT);
			*(shared21_ext_int + (k_loop +3*LOOPS)) = (int)(state[0][0]*FLOAT_TO_INT);
			*(shared21_ext_int + (k_loop +4*LOOPS)) = (int)(state[1][0]*FLOAT_TO_INT);
			*(shared21_ext_int + (k_loop +5*LOOPS)) = (int)(state[2][0]*FLOAT_TO_INT);
			*(shared21_ext_int + (k_loop +6*LOOPS)) = (int)(state[3][0]*FLOAT_TO_INT);
		}
		// -------------------------------------------------------------------------

		t_iter = t_iter + HP;
		while(*timer<t_iter);

	}


	// loop for debuggin ---------------------------------------------------------
	int k_temp = 0;
	uint32_t t21_lsb = 0;
	int aS_temp = 0;
	int s0_temp, s1_temp, s2_temp, s3_temp = 0;

	// xil_printf("k, t21, aS, s0, s1, s2, s3\n");

	for(k_loop=0; k_loop < LOOPS; k_loop++){
		k_temp = *(shared21_ext_int + (k_loop +0*LOOPS));
		t21_lsb = *(shared21_ext_uint32 + (k_loop +1*LOOPS));
		aS_temp = *(shared21_ext_int + (k_loop +2*LOOPS));

		s0_temp = *(shared21_ext_int + (k_loop +3*LOOPS));
		s1_temp = *(shared21_ext_int + (k_loop +4*LOOPS));
		s2_temp = *(shared21_ext_int + (k_loop +5*LOOPS));
		s3_temp = *(shared21_ext_int + (k_loop +6*LOOPS));

		// xil_printf("%d, %d, %d, %d, %d, %d, %d\n", k_temp, t21_lsb, aS_temp, s0_temp, s1_temp, s2_temp, s3_temp);
	}

}
