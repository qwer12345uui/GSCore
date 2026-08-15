ROOTLESS ?= 0
ROOTHIDE ?= 0

ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard
TARGET ?= iphone:clang:latest:15.0
PACKAGE_VERSION = 2.0.0

# Standard rootless and RootHide deliberately use distinct schemes.
# Do not infer RootHide from a fixed /var/jb prefix: RootHide randomizes jbroot.
ifeq ($(ROOTHIDE),1)
	THEOS_PACKAGE_SCHEME = roothide
	GSCore_SWIFTFLAGS += -DROOTHIDE
	GSCore_CFLAGS += -DROOTHIDE
	GSCore_LIBRARIES += roothide
else ifeq ($(ROOTLESS),1)
	THEOS_PACKAGE_SCHEME = rootless
	GSCore_SWIFTFLAGS += -DROOTLESS
	GSCore_CFLAGS += -DROOTLESS
endif

include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = GSCore
GSCore_FILES = $(shell find Sources/GSCore -name '*.swift') $(shell find Sources/GSCoreC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
GSCore_SWIFTFLAGS += -ISources/GSCoreC/include
GSCore_SWIFTFLAGS += -enable-library-evolution
GSCore_CFLAGS += -fobjc-arc -ISources/GSCoreC/include
GSCore_INSTALL_PATH = /Library/Frameworks

include $(THEOS_MAKE_PATH)/framework.mk

# Assemble the multi-arch .swiftmodule directory bundle into the framework
# before it's rsynced to $(THEOS)/lib (for dev consumption) and staged into
# the .deb. Theos emits one arch-specific flat module per arch; consumers
# resolve `import GSCore` by looking inside Modules/GSCore.swiftmodule/ for
# the target-triple-named file matching their build arch.
before-GSCore-stage::
	@mkdir -p $(THEOS_OBJ_DIR)/GSCore.framework/Modules/GSCore.swiftmodule
	@cp $(THEOS_OBJ_DIR)/arm64/GSCore.swiftmodule  $(THEOS_OBJ_DIR)/GSCore.framework/Modules/GSCore.swiftmodule/arm64-apple-ios.swiftmodule
	@cp $(THEOS_OBJ_DIR)/arm64e/GSCore.swiftmodule $(THEOS_OBJ_DIR)/GSCore.framework/Modules/GSCore.swiftmodule/arm64e-apple-ios.swiftmodule
