# Inherit common stuff
$(call inherit-product, vendor/xtended/config/common.mk)
$(call inherit-product, vendor/xtended/config/common_apn.mk)

# Telephony 
PRODUCT_PACKAGES += \
    Stk 

# SMS
PRODUCT_PACKAGES += \
	messaging
