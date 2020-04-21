# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

# Xtended System Version
ADDITIONAL_BUILD_PROPERTIES += \
    ro.xtended.version=$(XTENDED_VERSION) \
    ro.xtended.display.version=$(XTENDED_DISPLAY_VERSION) \
    ro.modversion=$(XTENDED_MOD_VERSION) \
    ro.xtended.buildtype=$(XTENDED_BUILD_TYPE) \
    ro.xtended.build.date=$(XTENDED_BUILD_DATE) \
    com.xtended.fingerprint=$(XTENDED_FINGERPRINT) \
    ro.xtended.releasetype=$(XTENDED_BUILD_TYPE) \
    ro.xtended.maintainer=$(XTENDED_MAINTAINER)
