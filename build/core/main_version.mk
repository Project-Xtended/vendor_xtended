# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

# Xtended System Version
ADDITIONAL_BUILD_PROPERTIES += \
    ro.xtended.build.date=$(XTENDED_BUILD_DATE) \
    ro.xtended.build.version=$(XTENDED_BUILD_VERSION) \
    ro.xtended.fingerprint=$(XTENDED_FINGERPRINT) \
    ro.xtended.releasetype=$(XTENDED_BUILD_TYPE) \
    ro.xtended.version=$(XTENDED_VERSION)E_PLATFORM_REV)
