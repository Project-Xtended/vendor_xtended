# Inherit mini common Xtended stuff
$(call inherit-product, vendor/xtended/config/common_mini.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

$(call inherit-product, vendor/xtended/config/telephony.mk)
