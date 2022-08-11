# Inherit common Xtended stuff
$(call inherit-product, vendor/xtended/config/common.mk)

# Inherit Xtended atv device tree
$(call inherit-product, device/xtended/atv/xtended_atv.mk)

# AOSP packages
PRODUCT_PACKAGES += \
    LeanbackIME

PRODUCT_PACKAGE_OVERLAYS += vendor/xtended/overlay/tv
