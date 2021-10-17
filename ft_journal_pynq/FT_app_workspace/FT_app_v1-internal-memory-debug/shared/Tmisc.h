#ifndef TMISC_H_
#define TMISC_H_

void multiply_matrix( int m,  int n,  int p,  int q,  float mA[m][n],  float mB[p][q], float mR[m][q]);
void add_matrix( int m,  int n,  float mA[m][n],  float mB[m][n], float mR[m][n]);
void sub_matrix( int m,  int n,  float mA[m][n],  float mB[m][n], float mR[m][n]);
void set_matrix( int m,  int n, float mS[m][n],  float set_value);

#endif
