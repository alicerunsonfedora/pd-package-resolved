HEAP_SIZE  	= 8388208
STACK_SIZE 	= 61800

PRODUCT = PackageResolved.pdx

# Locate the SDK
SDK = ${PLAYDATE_SDK_PATH}
ifeq ($(SDK),)
	SDK = $(shell egrep '^\s*SDKRoot' ~/.Playdate/config | head -n 1 | cut -c9-)
endif

ifeq ($(SDK),)
$(error SDK path not found; set ENV value PLAYDATE_SDK_PATH)
endif

VPATH += src

# List C source files here
SRC = src/main.c src/images.c 

# List test source files here
TESTS = test/test.c

# List test dependencies here
TESTS_DEPENDENTS = charolette/movement.c test/munit/munit.c

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

test: test/test.c test/munit/munit.h test/munit/munit.c
	gcc -o test/test_app -std=c11 -Icharolette -Itest/munit $(TESTS) $(TESTS_DEPENDENTS)

clean:
	$(MAKE) -f $(SDK)/C_API/buildsupport/common.mk $@
	rm -rf test/test_app