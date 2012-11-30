/*
 * KalmanPosition.c
 *
 * Code generation for function 'KalmanPosition'
 *
 * C source code generated on: Fri Nov 30 09:46:13 2012
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "KalmanPosition.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 10, "KalmanPosition",
  "H:/0000_SAMA_PIXHAWK/06_Logging/V11DamianFilter/KalmanPosition.m" };

static emlrtRSInfo b_emlrtRSI = { 11, "KalmanPosition",
  "H:/0000_SAMA_PIXHAWK/06_Logging/V11DamianFilter/KalmanPosition.m" };

static emlrtRSInfo c_emlrtRSI = { 14, "KalmanPosition",
  "H:/0000_SAMA_PIXHAWK/06_Logging/V11DamianFilter/KalmanPosition.m" };

static emlrtRSInfo d_emlrtRSI = { 49, "mtimes",
  "C:/Program Files/MATLAB/R2012a/toolbox/eml/lib/matlab/ops/mtimes.m" };

static emlrtRSInfo e_emlrtRSI = { 31, "eml_xdotu",
  "C:/Program Files/MATLAB/R2012a/toolbox/eml/lib/matlab/eml/blas/eml_xdotu.m" };

static emlrtRSInfo f_emlrtRSI = { 28, "eml_xdot",
  "C:/Program Files/MATLAB/R2012a/toolbox/eml/lib/matlab/eml/blas/eml_xdot.m" };

static emlrtRSInfo g_emlrtRSI = { 21, "eml_blas_xdot",
  "C:/Program Files/MATLAB/R2012a/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xdot.m"
};

static emlrtRSInfo h_emlrtRSI = { 14, "eml_refblas_xdot",
  "C:/Program Files/MATLAB/R2012a/toolbox/eml/lib/matlab/eml/blas/refblas/eml_refblas_xdot.m"
};

static emlrtRSInfo i_emlrtRSI = { 20, "eye",
  "C:/Program Files/MATLAB/R2012a/toolbox/eml/lib/matlab/elmat/eye.m" };

/* Function Declarations */

/* Function Definitions */
void KalmanPosition(const real32_T A[9], const real32_T B[3], const real32_T C[3],
                    real32_T x_aposteriori[3], real32_T P_aposteriori[9],
                    real32_T u, real32_T z, uint8_T gps_update, const real32_T
                    Q[9], real32_T R, real32_T thresh, real32_T decay)
{
  real32_T x_apriori[3];
  int32_T i;
  real32_T f0;
  int32_T i3;
  real32_T b_A[9];
  int32_T i4;
  real32_T P_apriori[9];
  real32_T y;
  real32_T K[3];
  real32_T S;
  int8_T I[9];

  /* prediction */
  for (i = 0; i < 3; i++) {
    f0 = 0.0F;
    for (i3 = 0; i3 < 3; i3++) {
      f0 += A[i + 3 * i3] * x_aposteriori[i3];
    }

    x_apriori[i] = f0 + B[i] * u;
  }

  for (i = 0; i < 3; i++) {
    for (i3 = 0; i3 < 3; i3++) {
      b_A[i + 3 * i3] = 0.0F;
      for (i4 = 0; i4 < 3; i4++) {
        b_A[i + 3 * i3] += A[i + 3 * i4] * P_aposteriori[i4 + 3 * i3];
      }
    }
  }

  for (i = 0; i < 3; i++) {
    for (i3 = 0; i3 < 3; i3++) {
      f0 = 0.0F;
      for (i4 = 0; i4 < 3; i4++) {
        f0 += b_A[i + 3 * i4] * A[i3 + 3 * i4];
      }

      P_apriori[i + 3 * i3] = f0 + Q[i + 3 * i3];
    }
  }

  if (muSingleScalarAbs(u) < thresh) {
    x_apriori[1] *= decay;
  }

  /* update */
  if (gps_update == 1) {
    EMLRTPUSHRTSTACK(&emlrtRSI);
    EMLRTPUSHRTSTACK(&d_emlrtRSI);
    EMLRTPUSHRTSTACK(&e_emlrtRSI);
    EMLRTPUSHRTSTACK(&f_emlrtRSI);
    EMLRTPUSHRTSTACK(&g_emlrtRSI);
    EMLRTPUSHRTSTACK(&h_emlrtRSI);
    y = 0.0F;
    for (i = 0; i < 3; i++) {
      y += C[i] * x_apriori[i];
    }

    EMLRTPOPRTSTACK(&h_emlrtRSI);
    EMLRTPOPRTSTACK(&g_emlrtRSI);
    EMLRTPOPRTSTACK(&f_emlrtRSI);
    EMLRTPOPRTSTACK(&e_emlrtRSI);
    EMLRTPOPRTSTACK(&d_emlrtRSI);
    y = z - y;
    EMLRTPOPRTSTACK(&emlrtRSI);
    EMLRTPUSHRTSTACK(&b_emlrtRSI);
    for (i = 0; i < 3; i++) {
      K[i] = 0.0F;
      for (i3 = 0; i3 < 3; i3++) {
        K[i] += C[i3] * P_apriori[i3 + 3 * i];
      }
    }

    EMLRTPUSHRTSTACK(&d_emlrtRSI);
    EMLRTPUSHRTSTACK(&e_emlrtRSI);
    EMLRTPUSHRTSTACK(&f_emlrtRSI);
    EMLRTPUSHRTSTACK(&g_emlrtRSI);
    EMLRTPUSHRTSTACK(&h_emlrtRSI);
    S = 0.0F;
    for (i = 0; i < 3; i++) {
      S += K[i] * C[i];
    }

    EMLRTPOPRTSTACK(&h_emlrtRSI);
    EMLRTPOPRTSTACK(&g_emlrtRSI);
    EMLRTPOPRTSTACK(&f_emlrtRSI);
    EMLRTPOPRTSTACK(&e_emlrtRSI);
    EMLRTPOPRTSTACK(&d_emlrtRSI);
    S += R;
    EMLRTPOPRTSTACK(&b_emlrtRSI);
    for (i = 0; i < 3; i++) {
      f0 = 0.0F;
      for (i3 = 0; i3 < 3; i3++) {
        f0 += P_apriori[i + 3 * i3] * C[i3];
      }

      K[i] = f0 / S;
    }

    for (i = 0; i < 3; i++) {
      x_aposteriori[i] = x_apriori[i] + K[i] * y;
    }

    EMLRTPUSHRTSTACK(&c_emlrtRSI);
    EMLRTPUSHRTSTACK(&i_emlrtRSI);
    for (i = 0; i < 9; i++) {
      I[i] = 0;
    }

    for (i = 0; i < 3; i++) {
      I[i + 3 * i] = 1;
    }

    EMLRTPOPRTSTACK(&i_emlrtRSI);
    for (i = 0; i < 3; i++) {
      for (i3 = 0; i3 < 3; i3++) {
        b_A[i3 + 3 * i] = (real32_T)I[i3 + 3 * i] - K[i3] * C[i];
      }
    }

    for (i = 0; i < 3; i++) {
      for (i3 = 0; i3 < 3; i3++) {
        P_aposteriori[i + 3 * i3] = 0.0F;
        for (i4 = 0; i4 < 3; i4++) {
          P_aposteriori[i + 3 * i3] += b_A[i + 3 * i4] * P_apriori[i4 + 3 * i3];
        }
      }
    }

    EMLRTPOPRTSTACK(&c_emlrtRSI);
  } else {
    for (i = 0; i < 3; i++) {
      x_aposteriori[i] = x_apriori[i];
    }

    for (i = 0; i < 3; i++) {
      for (i3 = 0; i3 < 3; i3++) {
        P_aposteriori[i3 + 3 * i] = P_apriori[i3 + 3 * i];
      }
    }
  }
}

/* End of code generation (KalmanPosition.c) */
