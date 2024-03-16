REPO_ROOT := ../PlaydateKit
PRODUCT := build/PackageResolved.pdx
include $(REPO_ROOT)/Examples/swift.mk

# MARK: - Build PlaydateKit Swift Module
build/Modules/playdatekit_device.o: $(REPO_ROOT)/Sources/PlaydateKit/*.swift
	$(SWIFT_EXEC) $(SWIFT_FLAGS) $(SWIFT_FLAGS_DEVICE) -c $^ -emit-module -o $@

build/Modules/playdatekit_simulator.o: $(REPO_ROOT)/Sources/PlaydateKit/*.swift
	$(SWIFT_EXEC) $(SWIFT_FLAGS) $(SWIFT_FLAGS_SIMULATOR) -c $^ -emit-module -o $@

# MARK: - Build BasicExample Swift Object
build/packageresolved_device.o: Sources/PackageResolved/*.swift | build/Modules/playdatekit_device.o
	$(SWIFT_EXEC) $(SWIFT_FLAGS) $(SWIFT_FLAGS_DEVICE) -c $^ -o $@
$(OBJDIR)/pdex.elf: build/packageresolved_device.o
OBJS += build/packageresolved_device.o

build/packageresolved_simulator.o: Sources/PackageResolved/*.swift | build/Modules/playdatekit_simulator.o
	$(SWIFT_EXEC) $(SWIFT_FLAGS) $(SWIFT_FLAGS_SIMULATOR) -c $^ -o $@
$(OBJDIR)/pdex.${DYLIB_EXT}: build/packageresolved_simulator.o
SIMCOMPILER += build/packageresolved_simulator.o
