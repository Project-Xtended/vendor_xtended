# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= MSM-XTENDED

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Default notification/alarm sounds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.notification_sound=Doink.ogg \
    ro.config.alarm_alert=Bright_morning.ogg

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Enable WiFi Display
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.wfd.nohdcp=1 \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0 

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1 \
    persist.sys.dun.override=0 \

# TEMP: Enable transitional log for Privileged permissions
PRODUCT_PRODUCT_PROPERTIES += \
    ro.control_privapp_permissions=log

# Some props that we need for the google stuff we're adding
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.ime.height_ratio=1.05 \
    ro.com.google.ime.emoji_key=false \
    ro.com.google.ime.theme_id=5

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# Tethering - allow without requiring a provisioning app
# (for devices that check this)
PRODUCT_PROPERTY_OVERRIDES += \
    net.tethering.noprovisioning=true

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/xtended/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/xtended/prebuilt/common/bin/50-xtended.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-xtended.sh

ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/xtended/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/xtended/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# system mount
PRODUCT_COPY_FILES += \
    vendor/xtended/build/tools/system-mount.sh:install/bin/system-mount.sh

# Backup services whitelist
PRODUCT_COPY_FILES += \
    vendor/xtended/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# Xtended-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/xtended/config/permissions/xtended-sysconfig.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/xtended-sysconfig.xml

# Copy all Xtended-specific init rc files
$(foreach f,$(wildcard vendor/xtended/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/lib/content-types.properties:$(TARGET_COPY_OUT_SYSTEM)/lib/content-types.properties

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/xtended/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# This is Xtended!
PRODUCT_COPY_FILES += \
   vendor/xtended/config/permissions/privapp-permissions-google_prebuilt.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-google_prebuilt.xml \
   vendor/xtended/config/permissions/privapp-permissions-xtended-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-xtended.xml \
   vendor/xtended/config/permissions/privapp-permissions-xtended-system.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-xtended.xml

# Hidden API whitelist
PRODUCT_COPY_FILES += \
    vendor/xtended/config/permissions/xtended-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/xtended-hiddenapi-package-whitelist.xml

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/xtended/config/permissions/xtended-power-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/xtended-power-whitelist.xml \
    vendor/xtended/config/permissions/qti_whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/qti_whitelist.xml

# Include AOSP audio files
include vendor/xtended/config/aosp_audio.mk

# Include Xtended audio files
include vendor/xtended/config/xtended_audio.mk

# Include Google fonts
include vendor/xtended/config/fonts.mk

# Bootanimation
include vendor/xtended/config/bootanimation.mk

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/xtended/config/twrp.mk
endif

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Xtended packages
PRODUCT_PACKAGES += \
    VinylMusicPlayer \
    Jelly \
    Calculator \
    BluetoothExt \
    ExactCalculator \
    GalleryGoPrebuilt \
    GBoardPrebuilt \
    SafetyHubPrebuilt \
    SettingsIntelligenceGooglePrebuilt \
    DevicePersonalizationServices \
    OPScreenRecorder \
    Longshot \
    OmniJaws \
    OmniStyle \
    Lawnchair \
    WallpaperPicker2 \
    PixelThemesStub2019

# Cutout control overlays
PRODUCT_PACKAGES += \
    HideCutout \
    StatusBarStock

# CustomDoze
PRODUCT_PACKAGES += \
    CustomDoze

# Extra tools in Xtended
PRODUCT_PACKAGES += \
    7z \
    awk \
    bash \
    bzip2 \
    curl \
    getcap \
    htop \
    lib7z \
    libsepol \
    nano \
    pigz \
    powertop \
    setcap \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Offline charger
PRODUCT_PACKAGES += \
    charger_res_images \
    product_charger_res_images

# Lawnchair
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/etc/permissions/privapp-permissions-lawnchair.xml:system/etc/permissions/privapp-permissions-lawnchair.xml \
    vendor/xtended/prebuilt/common/etc/sysconfig/lawnchair-hiddenapi-package-whitelist.xml:system/etc/sysconfig/lawnchair-hiddenapi-package-whitelist.xml

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
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

# Allows registering device to Google easier for gapps
# Integrates package for easier Google Pay fixing
PRODUCT_PACKAGES += \
    sqlite3

# rsync
PRODUCT_PACKAGES += \
    rsync

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

# Conditionally build in su
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    adb_root
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGES += \
    AndroidDarkThemeOverlay \
    SettingsDarkThemeOverlay

# Common overlay
DEVICE_PACKAGE_OVERLAYS += vendor/xtended/overlay/common

-include vendor/xtended/config/version.mk
-include vendor/xtended/config/partner_gms.mk

# Allow overlays to be excluded from enforcing RRO
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/xtended/overlay

# Include Xtended theme files
include vendor/xtended/themes/backgrounds/themes.mk

# Gapps
ifeq ($(WITH_GAPPS),true)
include vendor/gapps/config.mk
endif

# Enable ccache
USE_CCACHE := true
