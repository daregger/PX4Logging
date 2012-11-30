/*
 * positionKalmanFilter1D.c
 *
 * Code generation for function 'positionKalmanFilter1D'
 *
 * C source code generated on: Fri Nov 30 10:06:43 2012
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "positionKalmanFilter1D.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
void positionKalmanFilter1D(const real32_T A[9], const real32_T B[3], const
  real32_T C[3], real32_T x_aposteriori[3], real32_T P_aposteriori[9], real32_T
  u, real32_T z, uint8_T gps_update, const real32_T Q[9], real32_T R, real32_T
  thresh, real32_T decay)
{
  real32_T x_apriori[3];
  int32_T i0;
  real32_T f0;
  int32_T i;
  real32_T b_A[9];
  int32_T i1;
  real32_T P_apriori[9];
  real32_T y;
  real32_T K[3];
  real32_T S;
  int8_T I[9];

  /* prediction */
  for (i0 = 0; i0 < 3; i0++) {
    f0 = 0.0F;
    for (i = 0; i < 3; i++) {
      f0 += A[i0 + 3 * i] * x_aposteriori[i];
    }

    x_apriori[i0] = f0 + B[i0] * u;
  }

  for (i0 = 0; i0 < 3; i0++) {
    for (i = 0; i < 3; i++) {
      b_A[i0 + 3 * i] = 0.0F;
      for (i1 = 0; i1 < 3; i1++) {
        b_A[i0 + 3 * i] += A[i0 + 3 * i1] * P_aposteriori[i1 + 3 * i];
      }
    }
  }

  for (i0 = 0; i0 < 3; i0++) {
    for (i = 0; i < 3; i++) {
      f0 = 0.0F;
      for (i1 = 0; i1 < 3; i1++) {
        f0 += b_A[i0 + 3 * i1] * A[i + 3 * i1];
      }

      P_apriori[i0 + 3 * i] = f0 + Q[i0 + 3 * i];
    }
  }

  if ((real32_T)fabs(u) < thresh) {
    x_apriori[1] *= decay;
  }

  /* update */
  if (gps_update == 1) {
    y = 0.0F;
    for (i = 0; i < 3; i++) {
      y += C[i] * x_apriori[i];
      K[i] = 0.0F;
      for (i0 = 0; i0 < 3; i0++) {
        K[i] += C[i0] * P_apriori[i0 + 3 * i];
      }
    }

    y = z - y;
    S = 0.0F;
    for (i = 0; i < 3; i++) {
      S += K[i] * C[i];
    }

    S += R;
    for (i0 = 0; i0 < 3; i0++) {
      f0 = 0.0F;
      for (i = 0; i < 3; i++) {
        f0 += P_apriori[i0 + 3 * i] * C[i];
      }

      K[i0] = f0 / S;
    }

    for (i = 0; i < 3; i++) {
      x_aposteriori[i] = x_apriori[i] + K[i] * y;
    }

    for (i0 = 0; i0 < 9; i0++) {
      I[i0] = 0;
    }

    for (i = 0; i < 3; i++) {
      I[i + 3 * i] = 1;
    }

    for (i0 = 0; i0 < 3; i0++) {
      for (i = 0; i < 3; i++) {
        b_A[i + 3 * i0] = (real32_T)I[i + 3 * i0] - K[i] * C[i0];
      }
    }

    for (i0 = 0; i0 < 3; i0++) {
      for (i = 0; i < 3; i++) {
        P_aposteriori[i0 + 3 * i] = 0.0F;
        for (i1 = 0; i1 < 3; i1++) {
          P_aposteriori[i0 + 3 * i] += b_A[i0 + 3 * i1] * P_apriori[i1 + 3 * i];
        }
      }
    }
  } else {
    for (i = 0; i < 3; i++) {
      x_aposteriori[i] = x_apriori[i];
    }

    for (i0 = 0; i0 < 3; i0++) {
      for (i = 0; i < 3; i++) {
        P_aposteriori[i + 3 * i0] = P_apriori[i + 3 * i0];
      }
    }
  }
}

/* End of code generation (positionKalmanFilter1D.c) */
