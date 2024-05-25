REPO_ROOT := ../PlaydateKit
PRODUCT := build/PackageResolved.pdx
include swift.mk

# MARK: - Build PlaydateKit Swift Module
build/Modules/playdatekit_device.o: $(REPO_ROOT)/Sources/PlaydateKit/*.swift
	$(SWIFT_EXEC) $(SWIFT_FLAGS) $(SWIFT_FLAGS_DEVICE) -c $^ -emit-module -o $@

build/Modules/playdatekit_simulator.o: $(REPO_ROOT)/Sources/PlaydateKit/*.swift
	$(SWIFT_EXEC) $(SWIFT_FLAGS) $(SWIFT_FLAGS_SIMULATOR) -c $^ -emit-module -o $@

# MARK: - Charolette library
build/Modules/charolette_device.o: Sources/Charolette/*.swift
	$(SWIFT_EXEC) $(SWIFT_FLAGS) $(SWIFT_FLAGS_DEVICE) -c $^ -emit-module -o $@

build/Modules/charolette_simulator.o: Sources/Charolette/*.swift
	$(SWIFT_EXEC) $(SWIFT_FLAGS) $(SWIFT_FLAGS_SIMULATOR) -c $^ -emit-module -o $@

SWIFT_FLAGS_SIMULATOR += -module-alias Charolette=charolette_simulator
SWIFT_FLAGS_DEVICE += -module-alias Charolette=charolette_device

build/Modules/kdl_device.o: Sources/KDL/src/*.c
	$(SIMCOMPILER) $(C_FLAGS) $(C_FLAGS_DEVICE) -c $^ -emit-module -o $@

build/Modules/kdl_simulator.o: Sources/KDL/src/*.c
	clang -g -fuse-ld=lld $(C_FLAGS) $(C_FLAGS_SIMULATOR) -c $^

C_FLAGS += -I Sources/KDL/include
SWIFT_FLAGS_SIMULATOR += -module-alias KDL=kdl_simulator
SWIFT_FLAGS_DEVICE += -module-alias KDL=kdl_device

# MARK: - Build BasicExample Swift Object
build/packageresolved_device.o: Sources/PackageResolved/*.swift | build/Modules/kdl_device.o build/Modules/charolette_device.o build/Modules/playdatekit_device.o
	$(SWIFT_EXEC) $(SWIFT_FLAGS) $(SWIFT_FLAGS_DEVICE) -c $^ -o $@
$(OBJDIR)/pdex.elf: build/packageresolved_device.o
OBJS += build/packageresolved_device.o

build/packageresolved_simulator.o: Sources/PackageResolved/*.swift | build/Modules/kdl_simulator.o build/Modules/charolette_simulator.o build/Modules/playdatekit_simulator.o
	$(SWIFT_EXEC) $(SWIFT_FLAGS) $(SWIFT_FLAGS_SIMULATOR) -c $^ -o $@
$(OBJDIR)/pdex.${DYLIB_EXT}: build/packageresolved_simulator.o
SIMCOMPILER += build/packageresolved_simulator.o
