include vendor/xtended/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/xtended/config/BoardConfigQcom.mk
endif

include vendor/xtended/config/BoardConfigSoong.mk
