LOCAL_PATH := $(call my-dir)

#
# Prebuilt Gapps APKs
#

#Gboard App
include $(CLEAR_VARS)
LOCAL_MODULE := GboardGoPreb
ifeq ($(TARGET_ARCH),arm64)
    LOCAL_SRC_FILES := app/arm64/$(LOCAL_MODULE).apk
else ifeq ($(TARGET_ARCH),arm)
    LOCAL_SRC_FILES := app/arm/$(LOCAL_MODULE).apk
else ifeq ($(TARGET_ARCH),x86)
    LOCAL_SRC_FILES := app/x86/$(LOCAL_MODULE).apk
else ifeq ($(TARGET_ARCH),x86_64)
    LOCAL_SRC_FILES := app/x86_64/$(LOCAL_MODULE).apk
else
    $(error "Whoops: TARGET_ARCH isn't defined, so Gboard can't be built!")
endif
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_OVERRIDES_PACKAGES := LatinIME
include $(BUILD_PREBUILT)
