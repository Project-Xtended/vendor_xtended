# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= Project-Xtended

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1

# ART
# Optimize everything for preopt
PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := everything
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS), true)
# Don't preopt prebuilts
DONT_DEXPREOPT_PREBUILTS := true

# Use 64-bit dex2oat for better dexopt time.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat64.enabled=true
endif

PRODUCT_PROPERTY_OVERRIDES += \
    pm.dexopt.boot=verify \
    pm.dexopt.first-boot=quicken \
    pm.dexopt.install=speed-profile \
    pm.dexopt.bg-dexopt=everything

ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_PROPERTY_OVERRIDES += \
    pm.dexopt.ab-ota=quicken
endif

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

# Enable WiFi Display
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.wfd.nohdcp=1 \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/xtended/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/xtended/prebuilt/common/bin/50-xtended.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-xtended.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/xtended/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/xtended/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/xtended/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# Default and google apps privapp permissions
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/google/etc/sysconfig/nexus.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/nexus.xml \
    vendor/xtended/prebuilt/google/etc/sysconfig/pixel_2016_exclusive.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_2016_exclusive.xml \
    vendor/xtended/prebuilt/google/etc/sysconfig/pixel_experience_2017.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_experience_2017.xml \
    vendor/xtended/prebuilt/google/etc/sysconfig/pixel_experience_2018.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_experience_2018.xml \
    vendor/xtended/prebuilt/google/etc/sysconfig/pixel_experience_2019.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_experience_2019.xml \
    vendor/xtended/prebuilt/google/etc/sysconfig/pixel_experience_2019_midyear.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel__experience_2019_midyear.xml \
    vendor/xtended/prebuilt/google/etc/sysconfig/pixel_2019_exclusive.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_2019_exclusive.xml \
    vendor/xtended/prebuilt/google/etc/sysconfig/pixel_experience_2020.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_experience_2020.xml \
    vendor/xtended/prebuilt/google/etc/sysconfig/pixel_experience_2020_midyear.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_experience_2020_midyear.xml \
    vendor/xtended/prebuilt/google/etc/sysconfig/pixel_experience_2021.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_experience_2021.xml \
    vendor/xtended/prebuilt/google/etc/sysconfig/pixel_experience_2021_midyear.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_experience_2021_midyear.xml \
    vendor/xtended/prebuilt/google/etc/permissions/privapp-permissions-googleapps-turbo.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-googleapps-turbo.xml

# Xtended-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/xtended/config/permissions/xtended-sysconfig.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/xtended-sysconfig.xml

# Copy all Xtended-specific init rc files
$(foreach f,$(wildcard vendor/xtended/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Font service Permissions
PRODUCT_COPY_FILES += \
    vendor/xtended/config/permissions/privapp-permissions-xtended-system_ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-xtended-system_ext.xml \

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/xtended/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# Blur
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.launcher.blur.appLaunch=false

# Enforce privapp-permissions whitelist
PRODUCT_PRODUCT_PROPERTIES += \
    ro.control_privapp_permissions=log

# Include AOSP audio files
include vendor/xtended/config/aosp_audio.mk

# Include Xtended audio files
include vendor/xtended/config/xtended_audio.mk

# Include Lawnchair
ifeq ($(USE_LAWNCHAIR),true)
include packages/apps/Lawnchair/lawnchair.mk
endif

# Include vendor xtras
include vendor/xtras/xtras.mk

# Bootanimation
include vendor/xtended/bootanimation/bootanimation.mk

# Versioning
include vendor/xtended/config/version.mk

# Google apps and services
ifeq ($(WITH_GAPPS),true)

$(call inherit-product, vendor/gapps/common/common-vendor.mk)

# SetupWizard
PRODUCT_PRODUCT_PROPERTIES += \
    ro.setupwizard.rotation_locked=true \
    setupwizard.theme=glif_v3_light

# Google Assistant
PRODUCT_PRODUCT_PROPERTIES += \
    ro.opa.eligible_device=true

# Client ID
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.clientidbase=android-google

endif

# Full GAPPS
$(call inherit-product, vendor/xtended/config/gapps.mk)

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Clean up packages cache to avoid wrong strings and resources
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/bin/clean_cache.sh:system/bin/clean_cache.sh

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Bootanimation
TARGET_SCREEN_WIDTH ?= 1080
TARGET_SCREEN_HEIGHT ?= 1920

# Themes
PRODUCT_PACKAGES += \
    SoftAPManager \
    OmniJaws \
    GamingMode

ifneq ($(FULL_GAPPS),true)
PRODUCT_PACKAGES += \
    ThemePicker \
    XtendedThemesStub
endif

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# StitchImage
PRODUCT_PACKAGES += \
    StitchImage

# Extra tools in Xtended
PRODUCT_PACKAGES += \
    7z \
    bash \
    curl \
    getcap \
    htop \
    lib7z \
    libsepol \
    nano \
    pigz \
    setcap \
    unrar \
    vim \
    zip

# Offline charger
PRODUCT_PACKAGES += \
    product_charger_res_images

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mke2fs \
    mkfs.ntfs \
    mount.ntfs

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= true
ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    FaceUnlockService
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face_unlock_service.enabled=$(TARGET_FACE_UNLOCK_SUPPORTED)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/xtended/overlay/common
DEVICE_PACKAGE_OVERLAYS += vendor/xtended/overlay/common

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/xtended/config/partner_gms.mk
