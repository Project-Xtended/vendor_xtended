LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
<<<<<<< HEAD
LOCAL_MODULE_TAGS := optional
LOCAL_PACKAGE_NAME := PixelTheme
LOCAL_SDK_VERSION := current
LOCAL_CERTIFICATE := platform
LOCAL_PRIVILEGED_MODULE := false
include $(BUILD_PACKAGE)
=======

LOCAL_PACKAGE_NAME := PixelTheme
LOCAL_RRO_THEME := PixelTheme
LOCAL_CERTIFICATE := platform
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $(call all-subdir-java-files)
LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res

include $(BUILD_RRO_PACKAGE)
>>>>>>> 375792b... Push pixel theme overlay
