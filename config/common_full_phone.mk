# Inherit full common Xtended stuff
$(call inherit-product, vendor/xtended/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Xtended LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/xtended/overlay/dictionaries

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

$(call inherit-product, vendor/xtended/config/telephony.mk)
