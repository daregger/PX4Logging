/*
 * KalmanPosition_terminate.c
 *
 * Code generation for function 'KalmanPosition_terminate'
 *
 * C source code generated on: Fri Nov 30 09:46:12 2012
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "KalmanPosition.h"
#include "KalmanPosition_terminate.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
void KalmanPosition_atexit(void)
{
  emlrtEnterRtStack(&emlrtContextGlobal);
  emlrtLeaveRtStack(&emlrtContextGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void KalmanPosition_terminate(void)
{
  emlrtLeaveRtStack(&emlrtContextGlobal);
}

/* End of code generation (KalmanPosition_terminate.c) */
