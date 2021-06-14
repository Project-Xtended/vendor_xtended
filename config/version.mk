# Versioning System
XTENDED_MAJOR_VERSION = XR
XTENDED_RELEASE_VERSION = v7.0
XTENDED_BUILD_TYPE ?= UNOFFICIAL
XTENDED_BUILD_VARIANT ?= VANILLA
XTENDED_BUILD_MAINTAINER ?= Unknown
XTENDED_BUILD_DONATE_URL ?= https://www.paypal.me/sonal18
XTENDED_BUILD_SUPPORT_URL ?= https://t.me/XtendedOfficial

ifeq ($(WITH_GMS), true)
XTENDED_BUILD_VARIANT := GAPPS

PRODUCT_PACKAGES += \
    XtendedThemesStub
endif

# Xtended Release
ifeq ($(XTENDED_BUILD_TYPE), OFFICIAL)

ifeq ($(WITH_GAPPS), true)
XTENDED_BUILD_VARIANT := GAPPS
endif

# Updater
PRODUCT_PACKAGES += \
    Updater

  OFFICIAL_DEVICES = $(shell cat vendor/xtended/xtended.devices)
  FOUND_DEVICE =  $(filter $(XTENDED_BUILD), $(OFFICIAL_DEVICES))
    ifeq ($(FOUND_DEVICE),$(XTENDED_BUILD))
      XTENDED_BUILD_TYPE := OFFICIAL
    else
      XTENDED_BUILD_TYPE := UNOFFICIAL
      $(error Device is not official "$(XTENDED_BUILD)")
    endif
endif

# System version
TARGET_PRODUCT_SHORT := $(subst xtended_,,$(XTENDED_BUILD_TYPE))

XTENDED_DATE_YEAR := $(shell date -u +%Y)
XTENDED_DATE_MONTH := $(shell date -u +%m)
XTENDED_DATE_DAY := $(shell date -u +%d)

XTENDED_BUILD_DATE := $(XTENDED_DATE_YEAR)$(XTENDED_DATE_MONTH)$(XTENDED_DATE_DAY)
XTENDED_BUILD_VERSION := $(XTENDED_MAJOR_VERSION)-$(XTENDED_RELEASE_VERSION)
XTENDED_BUILD_FINGERPRINT := Xtended/$(XTENDED_MOD_VERSION)/$(TARGET_PRODUCT_SHORT)/$(XTENDED_BUILD_DATE)
XTENDED_VERSION := Xtended-$(XTENDED_BUILD_VERSION)-$(XTENDED_BUILD_VARIANT)-$(XTENDED_BUILD)-$(XTENDED_BUILD_TYPE)-$(XTENDED_BUILD_DATE)

PRODUCT_GENERIC_PROPERTIES += \
  ro.xtended.device=$(XTENDED_BUILD) \
  ro.xtended.version=$(XTENDED_VERSION) \
  ro.xtended.build.version=$(XTENDED_BUILD_VERSION) \
  ro.xtended.build.variant=$(XTENDED_BUILD_VARIANT) \
  ro.xtended.build.type=$(XTENDED_BUILD_TYPE) \
  ro.xtended.build.date=$(XTENDED_BUILD_DATE) \
  ro.xtended.build.fingerprint=$(XTENDED_BUILD_FINGERPRINT) \
  ro.xtended.build.maintainer=$(XTENDED_BUILD_MAINTAINER) \
  ro.xtended.build.donate_url=$(XTENDED_BUILD_DONATE_URL) \
  ro.xtended.build.support_url=$(XTENDED_BUILD_SUPPORT_URL)
