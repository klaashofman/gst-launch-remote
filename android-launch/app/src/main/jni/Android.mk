LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# Uncomment the next 2 lines to do debugging with ndk-gdb:
#APP_OPTIM:= debug
#LOCAL_CFLAGS    := -ggdb -O0

LOCAL_MODULE    := android_launch
LOCAL_SRC_FILES := android-launch.c ../../../../../gst-launch-remote/gst-launch-remote.c
LOCAL_SHARED_LIBRARIES := gstreamer_android c++_shared
LOCAL_LDLIBS := -llog -landroid
include $(BUILD_SHARED_LIBRARY)

ifndef GSTREAMER_ROOT_ANDROID
$(error GSTREAMER_ROOT_ANDROID is not defined!)
endif

ifeq ($(TARGET_ARCH_ABI),armeabi)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/arm
else ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/armv7
else ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/arm64
else ifeq ($(TARGET_ARCH_ABI),x86)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/x86
else ifeq ($(TARGET_ARCH_ABI),x86_64)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/x86_64
else
$(error Target arch ABI not supported: $(TARGET_ARCH_ABI))
endif

GSTREAMER_NDK_BUILD_PATH  := $(GSTREAMER_ROOT)/share/gst-android/ndk-build/
GSTREAMER_JAVA_SRC_DIR := $(LOCAL_PATH)/../java

include $(GSTREAMER_NDK_BUILD_PATH)/plugins.mk
GSTREAMER_PLUGINS         := $(GSTREAMER_PLUGINS_CORE) $(GSTREAMER_PLUGINS_PLAYBACK) $(GSTREAMER_PLUGINS_CODECS) $(GSTREAMER_PLUGINS_NET) $(GSTREAMER_PLUGINS_SYS) $(GSTREAMER_PLUGINS_CODECS_RESTRICTED)
GSTREANER_PLUGINS         += $(GSTREAMER_PLUGINS_CODECS_GPL) $(GSTREAMER_PLUGINS_ENCODING) $(GSTREAMER_PLUGINS_VIS) $(GSTREAMER_PLUGINS_EFFECTS) $(GSTREAMER_PLUGINS_NET_RESTRICTED)
GSTREAMER_PLUGINS         += $(GSTREAMER_PLUGINS_NET)
GSTREAMER_EXTRA_LIBS      := -liconv -lc++_shared
GSTREAMER_EXTRA_DEPS      := gstreamer-video-1.0 gstreamer-plugins-base-1.0 gstreamer-plugins-bad-1.0 gstreamer-webrtc-1.0 gstreamer-sdp-1.0
GSTREAMER_EXTRA_DEPS      += libsoup-2.4 json-glib-1.0
GSTREAMER_EXTRA_DEPS      += gio-2.0

include $(GSTREAMER_NDK_BUILD_PATH)/gstreamer-1.0.mk
