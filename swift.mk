HEAP_SIZE      = 8388208
STACK_SIZE     = 61800

# Locate the Playdate SDK
SDK = ${PLAYDATE_SDK_PATH}
ifeq ($(SDK),)
SDK = $(shell egrep '^\s*SDKRoot' ~/.Playdate/config | head -n 1 | cut -c9-)
endif

ifeq ($(SDK),)
$(error SDK path not found; set ENV value PLAYDATE_SDK_PATH)
endif

UINCDIR = Sources/KDL/include
ULIBDIR = Sources/KDL/include
SRC = Sources/KDL/src/bigint.c \
	  Sources/KDL/src/compat.c \
	  Sources/KDL/src/emitter.c \
	  Sources/KDL/src/parser.c \
	  Sources/KDL/src/str.c \
	  Sources/KDL/src/tokenizer.c \
	  Sources/KDL/src/utf8.c

include $(SDK)/C_API/buildsupport/common.mk

ifeq ($(detected_OS), Darwin)
	# Determine the Swift toolchain by order of preference:
	#
	# 1. the presence of a TOOLCHAINS environment value
	# 2. a Swift toolchain installed for the current user (e.g. 'Install for me only')
	# 3. a Swift toolchain installed for all users (e.g. 'Install for all users on this computer')
	TOOLCHAIN_PATH = Library/Developer/Toolchains/swift-latest.xctoolchain
	ifneq ($(TOOLCHAINS),)
	else ifneq ($(wildcard $(HOME)/$(TOOLCHAIN_PATH)),)
	TOOLCHAINS = $(shell plutil -extract CFBundleIdentifier raw -o - $(HOME)/$(TOOLCHAIN_PATH)/Info.plist)
	else ifneq ($(wildcard /$(TOOLCHAIN_PATH)),)
	TOOLCHAINS = $(shell plutil -extract CFBundleIdentifier raw -o - /$(TOOLCHAIN_PATH)/Info.plist)
	else
	$(error Swift toolchain not found; set ENV value TOOLCHAINS (e.g. TOOLCHAINS=org.swift.59202403121a make))
	endif
	SWIFT_EXEC := "$(shell TOOLCHAINS=$(TOOLCHAINS) xcrun -f swiftc)"
else
	SWIFT_EXEC := swiftc
endif

GCC_INCLUDE_PATHS := $(shell $(CC) -E -Wp,-v -xc /dev/null 2>&1 | egrep '^ ' | xargs echo )

C_FLAGS := \
	$(addprefix -I ,$(GCC_INCLUDE_PATHS)) \

SWIFT_FLAGS := \
	$(addprefix -Xcc , $(C_FLAGS)) \
	-g \
	-Osize \
	-wmo -enable-experimental-feature Embedded \
	-Xfrontend -disable-stack-protector \
	-Xfrontend -function-sections \
	-swift-version 6 \
	-Xcc -DTARGET_EXTENSION \
	-module-cache-path build/module-cache \
	-I $(SDK)/C_API \
	-I build/Modules \
	-I $(REPO_ROOT)/Sources/CPlaydate/include \
	-I Sources/KDL/include

C_FLAGS_DEVICE := \
	-mthumb \
	-mcpu=cortex-m7 \
	-mfloat-abi=hard \
	-mfpu=fpv5-sp-d16 \
	-D__FPU_USED=1 \
	-falign-functions=16 \
	-fshort-enums \

SWIFT_FLAGS_DEVICE := \
	$(addprefix -Xcc , $(C_FLAGS_DEVICE)) \
	-target armv7em-none-none-eabi \
	-Xfrontend -experimental-platform-c-calling-convention=arm_aapcs_vfp \
	-module-alias PlaydateKit=playdatekit_device \

C_FLAGS_SIMULATOR := \

SWIFT_FLAGS_SIMULATOR := \
	$(addprefix -Xcc , $(C_FLAGS_SIMULATOR)) \
	-module-alias PlaydateKit=playdatekit_simulator \

SIMCOMPILER += \
	-nostdlib \
	-dead_strip
