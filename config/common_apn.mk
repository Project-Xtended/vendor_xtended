# World APN list
PRODUCT_PACKAGES += \
    apns-conf.xml

# Selective SPN list for operator number who has the problem.
PRODUCT_COPY_FILES += \
    vendor/xtended/prebuilt/common/etc/selective-spn-conf.xml:system/etc/selective-spn-conf.xml

