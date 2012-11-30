/*
 * KalmanPosition_api.c
 *
 * Code generation for function 'KalmanPosition_api'
 *
 * C source code generated on: Fri Nov 30 09:46:13 2012
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "KalmanPosition.h"
#include "KalmanPosition_api.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
static void b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, real32_T y[9]);
static const mxArray *b_emlrt_marshallOut(const real32_T u[9]);
static void c_emlrt_marshallIn(const mxArray *B, const char_T *identifier,
  real32_T y[3]);
static void d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, real32_T y[3]);
static void e_emlrt_marshallIn(const mxArray *C, const char_T *identifier,
  real32_T y[3]);
static void emlrt_marshallIn(const mxArray *A, const char_T *identifier,
  real32_T y[9]);
static const mxArray *emlrt_marshallOut(const real32_T u[3]);
static void f_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, real32_T y[3]);
static real32_T g_emlrt_marshallIn(const mxArray *u, const char_T *identifier);
static real32_T h_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId);
static uint8_T i_emlrt_marshallIn(const mxArray *gps_update, const char_T
  *identifier);
static uint8_T j_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId);
static void k_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, real32_T ret[9]);
static void l_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, real32_T ret[3]);
static void m_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, real32_T ret[3]);
static real32_T n_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *
  msgId);
static uint8_T o_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId);

/* Function Definitions */
static void b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, real32_T y[9])
{
  k_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static const mxArray *b_emlrt_marshallOut(const real32_T u[9])
{
  const mxArray *y;
  static const int32_T iv1[2] = { 3, 3 };

  const mxArray *m1;
  real32_T (*pData)[];
  int32_T i;
  y = NULL;
  m1 = mxCreateNumericArray(2, (int32_T *)&iv1, mxSINGLE_CLASS, mxREAL);
  pData = (real32_T (*)[])mxGetData(m1);
  for (i = 0; i < 9; i++) {
    (*pData)[i] = u[i];
  }

  emlrtAssign(&y, m1);
  return y;
}

static void c_emlrt_marshallIn(const mxArray *B, const char_T *identifier,
  real32_T y[3])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  d_emlrt_marshallIn(emlrtAlias(B), &thisId, y);
  emlrtDestroyArray(&B);
}

static void d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, real32_T y[3])
{
  l_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void e_emlrt_marshallIn(const mxArray *C, const char_T *identifier,
  real32_T y[3])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  f_emlrt_marshallIn(emlrtAlias(C), &thisId, y);
  emlrtDestroyArray(&C);
}

static void emlrt_marshallIn(const mxArray *A, const char_T *identifier,
  real32_T y[9])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  b_emlrt_marshallIn(emlrtAlias(A), &thisId, y);
  emlrtDestroyArray(&A);
}

static const mxArray *emlrt_marshallOut(const real32_T u[3])
{
  const mxArray *y;
  static const int32_T iv0[1] = { 3 };

  const mxArray *m0;
  real32_T (*pData)[];
  int32_T i;
  y = NULL;
  m0 = mxCreateNumericArray(1, (int32_T *)&iv0, mxSINGLE_CLASS, mxREAL);
  pData = (real32_T (*)[])mxGetData(m0);
  for (i = 0; i < 3; i++) {
    (*pData)[i] = u[i];
  }

  emlrtAssign(&y, m0);
  return y;
}

static void f_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, real32_T y[3])
{
  m_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static real32_T g_emlrt_marshallIn(const mxArray *u, const char_T *identifier)
{
  real32_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  y = h_emlrt_marshallIn(emlrtAlias(u), &thisId);
  emlrtDestroyArray(&u);
  return y;
}

static real32_T h_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId)
{
  real32_T y;
  y = n_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static uint8_T i_emlrt_marshallIn(const mxArray *gps_update, const char_T
  *identifier)
{
  uint8_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  y = j_emlrt_marshallIn(emlrtAlias(gps_update), &thisId);
  emlrtDestroyArray(&gps_update);
  return y;
}

static uint8_T j_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId)
{
  uint8_T y;
  y = o_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void k_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, real32_T ret[9])
{
  int32_T iv2[2];
  int32_T i;
  int32_T i0;
  for (i = 0; i < 2; i++) {
    iv2[i] = 3;
  }

  emlrtCheckBuiltInCtxR2011b(&emlrtContextGlobal, msgId, src, "single", FALSE,
    2U, iv2);
  for (i = 0; i < 3; i++) {
    for (i0 = 0; i0 < 3; i0++) {
      ret[i0 + 3 * i] = (*(real32_T (*)[9])mxGetData(src))[i0 + 3 * i];
    }
  }

  emlrtDestroyArray(&src);
}

static void l_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, real32_T ret[3])
{
  int32_T iv3[1];
  int32_T i1;
  iv3[0] = 3;
  emlrtCheckBuiltInCtxR2011b(&emlrtContextGlobal, msgId, src, "single", FALSE,
    1U, iv3);
  for (i1 = 0; i1 < 3; i1++) {
    ret[i1] = (*(real32_T (*)[3])mxGetData(src))[i1];
  }

  emlrtDestroyArray(&src);
}

static void m_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, real32_T ret[3])
{
  int32_T iv4[2];
  int32_T i2;
  for (i2 = 0; i2 < 2; i2++) {
    iv4[i2] = 1 + (i2 << 1);
  }

  emlrtCheckBuiltInCtxR2011b(&emlrtContextGlobal, msgId, src, "single", FALSE,
    2U, iv4);
  for (i2 = 0; i2 < 3; i2++) {
    ret[i2] = (*(real32_T (*)[3])mxGetData(src))[i2];
  }

  emlrtDestroyArray(&src);
}

static real32_T n_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *
  msgId)
{
  real32_T ret;
  emlrtCheckBuiltInCtxR2011b(&emlrtContextGlobal, msgId, src, "single", FALSE,
    0U, 0);
  ret = *(real32_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static uint8_T o_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId)
{
  uint8_T ret;
  emlrtCheckBuiltInCtxR2011b(&emlrtContextGlobal, msgId, src, "uint8", FALSE, 0U,
    0);
  ret = *(uint8_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void KalmanPosition_api(const mxArray * const prhs[12], const mxArray *plhs[2])
{
  real32_T A[9];
  real32_T B[3];
  real32_T C[3];
  real32_T x_aposteriori[3];
  real32_T P_aposteriori[9];
  real32_T u;
  real32_T z;
  uint8_T gps_update;
  real32_T Q[9];
  real32_T R;
  real32_T thresh;
  real32_T decay;

  /* Marshall function inputs */
  emlrt_marshallIn(emlrtAliasP(prhs[0]), "A", A);
  c_emlrt_marshallIn(emlrtAliasP(prhs[1]), "B", B);
  e_emlrt_marshallIn(emlrtAliasP(prhs[2]), "C", C);
  c_emlrt_marshallIn(emlrtAliasP(prhs[3]), "x_aposteriori", x_aposteriori);
  emlrt_marshallIn(emlrtAliasP(prhs[4]), "P_aposteriori", P_aposteriori);
  u = g_emlrt_marshallIn(emlrtAliasP(prhs[5]), "u");
  z = g_emlrt_marshallIn(emlrtAliasP(prhs[6]), "z");
  gps_update = i_emlrt_marshallIn(emlrtAliasP(prhs[7]), "gps_update");
  emlrt_marshallIn(emlrtAliasP(prhs[8]), "Q", Q);
  R = g_emlrt_marshallIn(emlrtAliasP(prhs[9]), "R");
  thresh = g_emlrt_marshallIn(emlrtAliasP(prhs[10]), "thresh");
  decay = g_emlrt_marshallIn(emlrtAliasP(prhs[11]), "decay");

  /* Invoke the target function */
  KalmanPosition(A, B, C, x_aposteriori, P_aposteriori, u, z, gps_update, Q, R,
                 thresh, decay);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(x_aposteriori);
  plhs[1] = b_emlrt_marshallOut(P_aposteriori);
}

/* End of code generation (KalmanPosition_api.c) */
