/*
 * KalmanPosition.h
 *
 * Code generation for function 'KalmanPosition'
 *
 * C source code generated on: Fri Nov 30 09:53:36 2012
 *
 */

#ifndef __KALMANPOSITION_H__
#define __KALMANPOSITION_H__
/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>

#include "rtwtypes.h"
#include "KalmanPosition_types.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern void KalmanPosition(const real32_T A[9], const real32_T B[3], const real32_T C[3], real32_T x_aposteriori[3], real32_T P_aposteriori[9], real32_T u, real32_T z, uint8_T gps_update, const real32_T Q[9], real32_T R, real32_T thresh, real32_T decay);
#endif
/* End of code generation (KalmanPosition.h) */
