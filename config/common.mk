PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Set cache location
ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/data/cache
else
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/cache
endif

# Default ringtone/notification/alarm sounds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.ringtone=Zen_too.ogg,Hotline.ogg \
    ro.config.notification_sound=Doink.ogg \
    ro.config.alarm_alert=Bright_morning.ogg

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.require_network=any \
    ro.setupwizard.mode=OPTIONAL \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \
    ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent \
    ro.setupwizard.rotation_locked=true \
    ro.opa.eligible_device=true\
    persist.sys.wfd.nohdcp=1 \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0 \
    persist.sys.dun.override=0 \
    ro.com.google.ime.theme_id=5 \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0

# whitelist packages for location providers not in system
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.services.whitelist.packagelist=com.google.android.gms

# Bootanimation
TARGET_BOOTANIMATION_480P := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -le 480 ]; then \
    echo 'true'; \
  else \
    echo ''; \
  fi )

# Bootanimation
ifeq ($(TARGET_BOOTANIMATION_480P),true)
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/bootanimation/bootanimation-480p.zip:$(TARGET_COPY_OUT_SYSTEM)/media/bootanimation.zip
else
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/bootanimation/bootanimation.zip:$(TARGET_COPY_OUT_SYSTEM)/media/bootanimation.zip
endif

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Long screenshot
#PRODUCT_PACKAGES += \
    Longshot

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/xtended/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/xtended/prebuilt/common/bin/50-xtended.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-xtended.sh \
    vendor/xtended/prebuilt/common/bin/clean_cache.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/clean_cache.sh

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/xtended/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/xtended/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# Backup services whitelist
PRODUCT_COPY_FILES += \
    vendor/xtended/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# Gzosp-specific init file
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/etc/init.local.rc:root/init.xtended.rc

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/etc/init.d/50selinuxrelabel:$(TARGET_COPY_OUT_SYSTEM)/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /$(TARGET_COPY_OUT_SYSTEM)/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/etc/sysctl.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/sysctl.conf

# whitelist packages for location providers not in system
PRODUCT_PROPERTY_OVERRIDES += \
    ro.services.whitelist.packagelist=com.google.android.gms

# Fix Dialer
PRODUCT_COPY_FILES +=  \
#    vendor/xtended/prebuilt/common/sysconfig/dialer_experience.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/dialer_experience.xml

# Gzosp-specific startup services
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/etc/init.d/00banner:$(TARGET_COPY_OUT_SYSTEM)/etc/init.d/00banner \
    vendor/xtended/prebuilt/common/etc/init.d/90userinit:$(TARGET_COPY_OUT_SYSTEM)/etc/init.d/90userinit \
    vendor/xtended/prebuilt/common/bin/sysinit:$(TARGET_COPY_OUT_SYSTEM)/bin/sysinit

# Required packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    GboardGoPreb \
    Development \
    SpareParts

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# JamesDSP
#PRODUCT_PACKAGES += \
   libjamesdsp

#PRODUCT_PACKAGES += \
    Recorder

# MsmPapers
PRODUCT_PACKAGES += \
    MsmPapers

# Extra Optional packages
PRODUCT_PACKAGES += \
    Calculator \
    BluetoothExt \
    Lawnchair

# Lawnchair
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/etc/permissions/privapp-permissions-lawnchair.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-lawnchair.xml \
    vendor/xtended/prebuilt/common/etc/sysconfig/lawnchair-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/lawnchair-hiddenapi-package-whitelist.xml

# Cutout control overlays
PRODUCT_PACKAGES += \
    HideCutout \
    StatusBarStock

# QS tile styles
#PRODUCT_PACKAGES += \
    QStileCircleTrim \
    QStileDefault \
    QStileDualToneCircle \
    QStileSquircleTrim \
    QStileCookie \
    QStileAttemptMountain \
    QStileCircleDual \
    QStileCircleGradient \
    QStileDottedCircle \
    QStileNinja \
    QStilePokesign \
    QStileWavey \
    QStileInkDrop \
    QStileSquaremedo \
    QStileOreo \
    QStileOreoCircleTrim \
    QStileOreoSquircleTrim \
    QStilesCircleOutline \
    QSTileNeonLight \
    QSTileOxygen \
    QSTileTriangles

# Omni's PoorMan Themes
#PRODUCT_PACKAGES += \
    ContactsTheme \
    MessagesTheme \
    DocumentsUITheme \
    DialerTheme \
    TelecommTheme

# QS header styles
#PRODUCT_PACKAGES += \
    QSHeaderBlack \
    QSHeaderGrey \
    QSHeaderLightGrey \
    QSHeaderAccent \
    QSHeaderTransparent

#PRODUCT_PACKAGES += \
    NotificationsXtended \
    NotificationsBlack \
    NotificationsDark \
    NotificationsLight \
    NotificationsPrimary

#PRODUCT_PACKAGES += \
    AccentSluttyPink \
    AccentPixel \
    AccentGoldenShower \
    AccentDeepOrange \
    AccentMisticBrown \
    AccentOmni \
    AccentWhite \
    AccentTeal \
    AccentFromHell \
    AccentBlueMonday \
    AccentSmokingGreen \
    AccentDeadRed \
    AccentRottenOrange \
    AccentDeepPurple \
    AccentBlackMagic \
    AccentCandyRed \
    AccentJadeGreen \
    AccentPaleBlue \
    AccentPaleRed \
    AccentObfusBleu \
    AccentNotImpPurple \
    AccentHolillusion \
    AccentMoveMint \
    AccentFootprintPurple \
    AccentBubblegumPink \
    AccentFrenchBleu \
    AccentManiaAmber \
    AccentSeasideMint \
    AccentDreamyPurple \
    AccentSpookedPurple \
    AccentHeirloomBleu \
    AccentTruFilPink \
    AccentWarmthOrange \
    AccentColdBleu \
    AccentDiffDayGreen \
    AccentDuskPurple \
    AccentBurningRed \
    AccentHazedPink \
    AccentColdYellow \
    AccentNewHouseOrange \
    AccentIllusionsPurple \
    AccentFlare \
    AccentSublime \
    AccentSincityRed \
    AccentOrangeCoral \
    AccentPureLust \
    AccentQuepal \
    AccentShadesOfGrey \
    AccentBobBlue

#PRODUCT_PACKAGES += \
    PrimaryAlmostBlack \
    PrimaryBlack \
    PrimaryXtended \
    PrimaryXtendedClear \
    PrimaryEyeSoother \
    PrimaryOmni \
    PrimaryWhite \
    PrimaryColdWhite \
    PrimaryWarmWhite \
    PrimaryDarkBlue

# CustomDoze
PRODUCT_PACKAGES += \
    CustomDoze

# Build OTA for Official Only
#PRODUCT_PACKAGES += XOta

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    libsepol \
    nano \
    htop \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    pigz \
    7z \
    lib7z \
    bash \
    bzip2 \
    curl \
    getcap \
    powertop \
    setcap \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Xtended Stuff - Copy to System fonts
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/fonts/gobold/Gobold.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/Gobold.ttf \
    vendor/xtended/prebuilt/fonts/gobold/Gobold-Italic.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/Gobold-Italic.ttf \
    vendor/xtended/prebuilt/fonts/gobold/GoboldBold.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoboldBold.ttf \
    vendor/xtended/prebuilt/fonts/gobold/GoboldBold-Italic.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoboldBold-Italic.ttf \
    vendor/xtended/prebuilt/fonts/gobold/GoboldThinLight.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoboldThinLight.ttf \
    vendor/xtended/prebuilt/fonts/gobold/GoboldThinLight-Italic.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoboldThinLight-Italic.ttf \
    vendor/xtended/prebuilt/fonts/roadrage/road_rage.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/RoadRage-Regular.ttf \
    vendor/xtended/prebuilt/fonts/neoneon/neoneon.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/Neoneon-Regular.ttf \
    vendor/xtended/prebuilt/fonts/mexcellent/mexcellent.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/Mexcellent-Regular.ttf \
    vendor/xtended/prebuilt/fonts/burnstown/burnstown.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/Burnstown-Regular.ttf \
    vendor/xtended/prebuilt/fonts/dumbledor/dumbledor.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/Dumbledor-Regular.ttf \
    vendor/xtended/prebuilt/fonts/PhantomBold/PhantomBold.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/PhantomBold-Regular.ttf \
    vendor/xtended/prebuilt/fonts/snowstorm/snowstorm.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/Snowstorm-Regular.ttf \
    vendor/xtended/prebuilt/fonts/vcrosd/vcr_osd_mono.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/ThemeableFont-Regular.ttf \
    vendor/xtended/prebuilt/fonts/Shamshung/Shamshung.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/Shamshung.ttf

# DU Font Engine
#PRODUCT_PACKAGES += \
   DU-Fonts

# Thermal Control Engine
#PRODUCT_PACKAGES += \
   ThermalController

#PRODUCT_PACKAGES += \
    charger_res_images

# Storage manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=true

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGES += \
    AndroidDarkThemeOverlay \
    SettingsDarkThemeOverlay

PRODUCT_PACKAGE_OVERLAYS += vendor/xtended/overlay/common

# SubstratumSignature Package
#PRODUCT_COPY_FILES += \
     vendor/xtended/prebuilt/common/app/SubstratumSignature.apk:$(TARGET_COPY_OUT_SYSTEM)/priv-app/SubstratumSignature/SubstratumSignature.apk

# Themes
#$(call inherit-product-if-exists, vendor/xtended/products/themes.mk)

# Versioning System
# Xtended first version.
PRODUCT_VERSION_MAJOR = 10.0
PRODUCT_VERSION_MAINTENANCE = XQ-Alpha
XTENDED_RELEASE_VERSION = Pre-Release-v1
XTENDED_POSTFIX := $(shell date +"%Y%m%d")
XTENDED_BUILD_EXTRA := By-Team-Xtended
ifndef XTENDED_BUILD_TYPE
    XTENDED_BUILD_TYPE := UNOFFICIAL
endif

# Set all versions
XTENDED_VERSION := Xtended-$(XTENDED_BUILD)-$(XTENDED_POSTFIX)-$(PRODUCT_VERSION_MAINTENANCE)-$(XTENDED_BUILD_TYPE)-$(XTENDED_RELEASE_VERSION)
XTENDED_MOD_VERSION := Xtended-$(XTENDED_BUILD)-$(XTENDED_POSTFIX)-$(PRODUCT_VERSION_MAINTENANCE)-$(XTENDED_BUILD_TYPE)-$(XTENDED_RELEASE_VERSION)
ROM_FINGERPRINT := Xtended-$(XTENDED_BUILD)-$(XTENDED_POSTFIX)-$(PRODUCT_VERSION_MAINTENANCE)-$(XTENDED_RELEASE_VERSION)
XTENDED_XTRA_VERSION := $(XTENDED_BUILD_TYPE)-$(PRODUCT_VERSION_MAINTENANCE)-$(XTENDED_RELEASE_VERSION)
XTENDED_DISPLAY_VERSION := $(XTENDED_XTRA_VERSION)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    xtended.ota.version=$(XTENDED_VERSION) \
    ro.xtended.version=$(XTENDED_XTRA_VERSION) \
    ro.modversion=$(XTENDED_MOD_VERSION) \
    ro.xtended.buildtype=$(XTENDED_BUILD_TYPE) \
    ro.xtended.display.version=$(XTENDED_DISPLAY_VERSION) \
    com.xtended.fingerprint=$(ROM_FINGERPRINT)

# Google sounds
include vendor/xtended/google/GoogleAudio.mk

# Some props that we need for the google stuff we're adding
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.ime.height_ratio=1.05 \
    ro.com.google.ime.emoji_key=false

EXTENDED_POST_PROCESS_PROPS := vendor/xtended/tools/xtended_process_props.py

# Fonts
PRODUCT_COPY_FILES += \
    vendor/xtended/fonts/GoogleSans-Regular.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoogleSans-Regular.ttf \
    vendor/xtended/fonts/GoogleSans-Medium.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoogleSans-Medium.ttf \
    vendor/xtended/fonts/GoogleSans-MediumItalic.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoogleSans-MediumItalic.ttf \
    vendor/xtended/fonts/GoogleSans-Italic.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoogleSans-Italic.ttf \
    vendor/xtended/fonts/GoogleSans-Bold.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoogleSans-Bold.ttf \
    vendor/xtended/fonts/GoogleSans-BoldItalic.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoogleSans-BoldItalic.ttf

# Include SDCLANG definitions if it is requested and available
ifeq ($(HOST_OS),linux)
    ifneq ($(wildcard vendor/qcom/sdclang/),)
        include vendor/xtended/sdclang/sdllvm-lto-defs.mk
    endif
endif


