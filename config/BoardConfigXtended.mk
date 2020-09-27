# Charger
ifeq ($(WITH_XTENDED_CHARGER),true)
    BOARD_HAL_STATIC_LIBRARIES := libhealthd.xtended
endif

include vendor/xtended/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/xtended/config/BoardConfigQcom.mk
endif

include vendor/xtended/config/BoardConfigSoong.mk
