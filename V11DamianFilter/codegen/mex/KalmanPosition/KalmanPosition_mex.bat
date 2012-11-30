@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2012a
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2012a\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=KalmanPosition_mex
set MEX_NAME=KalmanPosition_mex
set MEX_EXT=.mexw64
call mexopts.bat
echo # Make settings for KalmanPosition > KalmanPosition_mex.mki
echo COMPILER=%COMPILER%>> KalmanPosition_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> KalmanPosition_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> KalmanPosition_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> KalmanPosition_mex.mki
echo LINKER=%LINKER%>> KalmanPosition_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> KalmanPosition_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> KalmanPosition_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> KalmanPosition_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> KalmanPosition_mex.mki
echo BORLAND=%BORLAND%>> KalmanPosition_mex.mki
echo OMPFLAGS= >> KalmanPosition_mex.mki
echo OMPLINKFLAGS= >> KalmanPosition_mex.mki
echo EMC_COMPILER=msvc100>> KalmanPosition_mex.mki
echo EMC_CONFIG=optim>> KalmanPosition_mex.mki
"C:\Program Files\MATLAB\R2012a\bin\win64\gmake" -B -f KalmanPosition_mex.mk
