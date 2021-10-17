#include <stdio.h>
#include <stdint.h>
#include <memmap.h>
#include <stdint.h>
#include <xil_printf.h>


#define N  5 // System
#define HP 10000 // hp = 100us
#define FLOAT_TO_INT 100000 // float2int constant factor

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

	// System Parameters ---------------------------------------------------------
  float A[N-1][N-1] = {
  	{952.1801e-003f,   47.81994e-003f,   89.54654e-006f,   7.994606e-006f},
    {47.81994e-003f,   952.1801e-003f,   7.994606e-006f,   89.54654e-006f},
    {-887.7336e+000f,   887.7336e+000f,   787.1992e-003f,   164.0302e-003f},
    {887.7336e+000f,  -887.7336e+000f,   164.0302e-003f,   787.1992e-003f}
  };
  float B[N-1][1] = {{4.643475e-003f}, {261.6827e-006f}, {89.31820e+000f}, {7.974220e+000f}};

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


	// synchronization with tile 0 -----------------------------------------------
	*(shared02+10) = 2;
  // ---------------------------------------------------------------------------


	t_iter = *timer;

	while(1){

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

		t_iter = t_iter + HP;
	  while(*timer<t_iter);

  }
}
