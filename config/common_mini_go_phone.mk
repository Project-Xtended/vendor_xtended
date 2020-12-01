# Set Lineage specific identifier for Android Go enabled products
PRODUCT_TYPE := go

# Inherit mini common Xtended stuff
$(call inherit-product, vendor/xtended/config/common_mini_phone.mk)
