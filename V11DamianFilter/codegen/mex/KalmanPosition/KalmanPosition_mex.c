/*
 * KalmanPosition_mex.c
 *
 * Code generation for function 'KalmanPosition'
 *
 * C source code generated on: Fri Nov 30 09:46:13 2012
 *
 */

/* Include files */
#include "mex.h"
#include "KalmanPosition_api.h"
#include "KalmanPosition_initialize.h"
#include "KalmanPosition_terminate.h"

/* Type Definitions */

/* Function Declarations */
static void KalmanPosition_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);
MEXFUNCTION_LINKAGE mxArray *emlrtMexFcnProperties(void);

/* Variable Definitions */
emlrtContext emlrtContextGlobal = { true, false, EMLRT_VERSION_INFO, NULL, "KalmanPosition", NULL, false, {2045744189U,2170104910U,2743257031U,4284093946U}, 0, false, 1, false };

/* Function Definitions */
static void KalmanPosition_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Temporary copy for mex outputs. */
  mxArray *outputs[2];
  int n = 0;
  int nOutputs = (nlhs < 1 ? 1 : nlhs);
  /* Check for proper number of arguments. */
  if(nrhs != 12) {
    mexErrMsgIdAndTxt("emlcoder:emlmex:WrongNumberOfInputs","12 inputs required for entry-point 'KalmanPosition'.");
  } else if(nlhs > 2) {
    mexErrMsgIdAndTxt("emlcoder:emlmex:TooManyOutputArguments","Too many output arguments for entry-point 'KalmanPosition'.");
  }
  /* Module initialization. */
  KalmanPosition_initialize(&emlrtContextGlobal);
  /* Call the function. */
  KalmanPosition_api(prhs,(const mxArray**)outputs);
  /* Copy over outputs to the caller. */
  for (n = 0; n < nOutputs; ++n) {
    plhs[n] = emlrtReturnArrayR2009a(outputs[n]);
  }
  /* Module finalization. */
  KalmanPosition_terminate();
}

void KalmanPosition_atexit_wrapper(void)
{
  KalmanPosition_atexit();
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Initialize the memory manager. */
  mexAtExit(KalmanPosition_atexit_wrapper);
  emlrtClearAllocCount(&emlrtContextGlobal, 0, 0, NULL);
  /* Dispatch the entry-point. */
  KalmanPosition_mexFunction(nlhs, plhs, nrhs, prhs);
}

mxArray *emlrtMexFcnProperties(void)
{
    const char *mexProperties[] = {
        "Version",
        "EntryPoints"};
    const char *epProperties[] = {
        "Name",
        "NumberOfInputs",
        "NumberOfOutputs",
        "ConstantInputs"};
    mxArray *xResult = mxCreateStructMatrix(1,1,2,mexProperties);
    mxArray *xEntryPoints = mxCreateStructMatrix(1,1,4,epProperties);
    mxArray *xInputs = NULL;
    xInputs = mxCreateLogicalMatrix(1, 12);
    mxSetFieldByNumber(xEntryPoints, 0, 0, mxCreateString("KalmanPosition"));
    mxSetFieldByNumber(xEntryPoints, 0, 1, mxCreateDoubleScalar(12));
    mxSetFieldByNumber(xEntryPoints, 0, 2, mxCreateDoubleScalar(2));
    mxSetFieldByNumber(xEntryPoints, 0, 3, xInputs);
    mxSetFieldByNumber(xResult, 0, 0, mxCreateString("7.14.0.739 (R2012a)"));
    mxSetFieldByNumber(xResult, 0, 1, xEntryPoints);

    return xResult;
}
/* End of code generation (KalmanPosition_mex.c) */
