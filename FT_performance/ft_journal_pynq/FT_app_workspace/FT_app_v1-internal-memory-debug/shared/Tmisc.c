#include "Tmisc.h"

// --------------------------------------- MATRIX OPERATIONS FUNCTIONS ---------------------------------------------- //
/* Function for matrix multiplications: matrixA with mxn dimension, matrixB with pxq dimension */
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

/* Function for matrix subtraction */
void sub_matrix( int m,  int n,  float mA[m][n],  float mB[m][n], float mR[m][n])
{
	int i = 0;
	int j = 0;

	for ( i=0; i<m; i++ ){
		for ( j=0; j<n; j++ ){
			mR[i][j] = mA[i][j] - mB[i][j];
		}
	}
}

/* Set array values */
void set_matrix( int m,  int n, float mS[m][n],  float set_value)
{
	int i = 0;
	int j = 0;

	for ( i=0; i<m; i++ ){
		for ( j=0; j<n; j++ ){
			mS[i][j] =  set_value;
		}
	}
}
