###
# Copyright Veritec
# Makefile for compiling code on a tile.
#
# This uses depedencies files fo dependency tracking.
##

# Include the tile specific flags.
include ../tiles/tile${TILE_ID}_mb.mk

# Name used by xilinx for this specific tile.
TILE_NAME:=tile${TILE_ID}_mb

TARGET  := mb.elf

CFLAGS += ${COMPILER_FLAGS}
CFLAGS += $(USER_FLAGS)
CFLAGS += -I${WORKSPACE}/bsp_${TILE_NAME}/${TILE_NAME}/include/
CFLAGS += -I${WORKSPACE}/tiles/

# Library
CFLAGS += $(foreach lib,$(USER_LIBS),-I${WORKSPACE}/lib$(lib)/include/)
USER_LIBS_TARGETS := $(foreach lib,$(USER_LIBS),${WORKSPACE}/lib$(lib)/lib/lib$(lib)_$(TILE_NAME).a)

##
# Default target
##
all: $(TARGET)

define LIBRARY_DEP
$(WORKSPACE)/lib$(1)/lib/lib$(1)_$(TILE_NAME).a:
	make -C $(WORKSPACE)/lib$(1)/

clean-lib$(1):
	make -C $(WORKSPACE)/lib$(1)/ clean

realclean: clean-lib$(1)
endef

$(foreach lib,$(USER_LIBS),$(eval $(call LIBRARY_DEP,$(lib))))

# TODO filter on C/C++ sources separate.
OBJECTS 	 := ${SOURCES:.c=.o}
OBJECTS 	 := ${OBJECTS:.s=.o}
OBJECTS 	 := ${OBJECTS:.S=.o}
DEPENDENCIES := ${SOURCES:.c=.d}

LINKER_SCRIPT := ${WORKSPACE}/tiles/${TILE_NAME}.ld

MB_GCC := mb-gcc
MB_OBJCOPY := mb-objcopy

realclean: clean

clean:
	-rm -f out.hex ${OBJECTS} ${DEPENDENCIES} ${TARGET}

%.d  %.o: %.c  | ${WORKSPACE}/bsp_${TILE_NAME}/${TILE_NAME}/lib/libxil.a
	${MB_GCC} ${CFLAGS} -MMD -MP $< -c -o ${^:.c=.o}

ifeq (clean,$(MAKECMDGOALS))
else
ifeq (realclean,$(MAKECMDGOALS))
else
-include ${DEPENDENCIES}
endif
endif

# Create elf file
${TARGET}: ${OBJECTS} $(USER_LIBS_TARGETS)
	${MB_GCC} ${CFLAGS} -Wl,-T -Wl,${LINKER_SCRIPT}  -o $@ ${OBJECTS} -L${WORKSPACE}/bsp_${TILE_NAME}/${TILE_NAME}/lib/\
	   $(foreach lib,$(USER_LIBS),-L$(WORKSPACE)/lib$(lib)/lib/ -l$(lib)_$(TILE_NAME))
	${MB_OBJCOPY} --remove-section='.partition.*' -g  -Obinary ${TARGET} out.hex

# Make sure the bsp is compiled (as it copies files)
# before anything else.
${WORKSPACE}/bsp_${TILE_NAME}/${TILE_NAME}/lib/libxil.a:
	make -C ${WORKSPACE}/bsp_${TILE_NAME}

.PHONY: clean realclean all
