# Inherit common Xtended stuff
$(call inherit-product, vendor/xtended/config/common_mobile.mk)

PRODUCT_SIZE := full

# Recorder
PRODUCT_PACKAGES += \
    Recorder
