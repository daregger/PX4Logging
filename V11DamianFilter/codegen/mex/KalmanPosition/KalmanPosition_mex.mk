MATLAB_ROOT = C:\PROGRA~1\MATLAB\R2012a
MAKEFILE = KalmanPosition_mex.mk

include KalmanPosition_mex.mki


SRC_FILES =  \
	KalmanPosition_initialize.c \
	KalmanPosition_terminate.c \
	KalmanPosition.c \
	KalmanPosition_api.c \
	KalmanPosition_mex.c

MEX_FILE_NAME_WO_EXT = KalmanPosition_mex
MEX_FILE_NAME = $(MEX_FILE_NAME_WO_EXT).mexw64
TARGET = $(MEX_FILE_NAME)

SYS_LIBS = 


#
#====================================================================
# gmake makefile fragment for building MEX functions using MSVC
# Copyright 2007-2011 The MathWorks, Inc.
#====================================================================
#
SHELL = cmd
OBJEXT = obj
CC = $(COMPILER)
LD = $(LINKER)
.SUFFIXES: .$(OBJEXT)

OBJLISTC = $(SRC_FILES:.c=.$(OBJEXT))
OBJLIST  = $(OBJLISTC:.cpp=.$(OBJEXT))

ifneq (,$(findstring $(EMC_COMPILER),msvc80 msvc90 msvc100 msvc100free msvcsdk))
  TARGETMT = $(TARGET).manifest
  MEX = $(TARGETMT)
  STRICTFP = /fp:strict
else
  MEX = $(TARGET)
  STRICTFP = /Op
endif

target: $(MEX)

MATLAB_INCLUDES = /I "$(MATLAB_ROOT)\extern\include"
MATLAB_INCLUDES+= /I "$(MATLAB_ROOT)\simulink\include"
MATLAB_INCLUDES+= /I "$(MATLAB_ROOT)\toolbox\shared\simtargets"
MATLAB_INCLUDES+= /I "$(MATLAB_ROOT)\rtw\ext_mode\common"
MATLAB_INCLUDES+= /I "$(MATLAB_ROOT)\rtw\c\src\ext_mode\common"
SYS_INCLUDE = $(MATLAB_INCLUDES)

# Additional includes

SYS_INCLUDE += /I "H:\0000_SAMA_PIXHAWK\06_Logging\V11DamianFilter\codegen\mex\KalmanPosition"
SYS_INCLUDE += /I "H:\0000_SAMA_PIXHAWK\06_Logging\V11DamianFilter"

DIRECTIVES = $(MEX_FILE_NAME_WO_EXT)_mex.arf

COMP_FLAGS = $(COMPFLAGS) $(OMPFLAGS) -DMX_COMPAT_32
LINK_FLAGS = $(filter-out /export:mexFunction, $(LINKFLAGS))
LINK_FLAGS += /NODEFAULTLIB:LIBCMT
ifeq ($(EMC_CONFIG),optim)
  COMP_FLAGS += $(OPTIMFLAGS) $(STRICTFP)
  LINK_FLAGS += $(LINKOPTIMFLAGS)
else
  COMP_FLAGS += $(DEBUGFLAGS)
  LINK_FLAGS += $(LINKDEBUGFLAGS)
endif
LINK_FLAGS += $(OMPLINKFLAGS)
LINK_FLAGS += /OUT:$(TARGET)
LINK_FLAGS += 

CFLAGS =  $(COMP_FLAGS) $(USER_INCLUDE) $(SYS_INCLUDE)
CPPFLAGS =  $(CFLAGS)

%.$(OBJEXT) : %.c
	$(CC) $(CFLAGS) "$<"

%.$(OBJEXT) : %.cpp
	$(CC) $(CPPFLAGS) "$<"

# Additional sources

%.$(OBJEXT) : H:\0000_SAMA_PIXHAWK\06_Logging\V11DamianFilter\codegen\mex\KalmanPosition/%.c
	$(CC) $(CFLAGS) "$<"



%.$(OBJEXT) : H:\0000_SAMA_PIXHAWK\06_Logging\V11DamianFilter\codegen\mex\KalmanPosition/%.cpp
	$(CC) $(CPPFLAGS) "$<"



$(TARGET): $(OBJLIST) $(MAKEFILE) $(DIRECTIVES)
	$(LD) $(LINK_FLAGS) $(OBJLIST) $(USER_LIBS) $(SYS_LIBS) @$(DIRECTIVES)
	@cmd /C "echo Build completed using compiler $(EMC_COMPILER)"

$(TARGETMT): $(TARGET)
	mt -outputresource:"$(TARGET);2" -manifest "$(TARGET).manifest"

#====================================================================

