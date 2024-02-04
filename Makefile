HEAP_SIZE  	= 8388208
STACK_SIZE 	= 61800

PRODUCT = PackageResolved.pdx

UNAME_S := $(shell uname -s)

# Set the appropriate C compiler for the unit tests.
CLANGD := $(shell which clang)
ifeq ($(CLANGD),)
	TEST_CC := gcc 
else
	TEST_CC := clang 
endif

# Update the flags to allow linking to the math lib.
ifeq ($(UNAME_S), Linux)
	TEST_CC_FLAGS := -lm
endif

# Locate the SDK
SDK = ${PLAYDATE_SDK_PATH}
ifeq ($(SDK),)
	SDK = $(shell egrep '^\s*SDKRoot' ~/.Playdate/config | head -n 1 | cut -c9-)
endif

ifeq ($(SDK),)
$(error SDK path not found; set ENV value PLAYDATE_SDK_PATH)
endif

VPATH += src

# Source files for the Charolette lib
CHAROLETTE_SRC = charolette/movement.c \
	charolette/boxes.c \
	charolette/vector.c

# List C source files here
SRC = src/main.c src/images.c $(CHAROLETTE_SRC)

# List test source files here
TESTS = test/test.c

# List test dependencies here
TESTS_DEPENDENTS = test/munit/munit.c $(CHAROLETTE_SRC)

# List all user directories here
UINCDIR = charolette

# List user asm files
UASRC = 

# List all user C define here, like -D_DEBUG=1
UDEFS = 

# Define ASM defines here
UADEFS = 

# List the user directory to look for the libraries here
ULIBDIR =

# List all user libraries here
ULIBS =

include $(SDK)/C_API/buildsupport/common.mk

# Unit tests.
test: test/test.c test/munit/munit.h test/munit/munit.c
	$(TEST_CC) -o test/test_app -std=c11 -Icharolette -Itest/munit $(TESTS) $(TESTS_DEPENDENTS) $(TEST_CC_FLAGS)

clean:
	$(MAKE) -f $(SDK)/C_API/buildsupport/common.mk $@
	rm -rf test/test_app
