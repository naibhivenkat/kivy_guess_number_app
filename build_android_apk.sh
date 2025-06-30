#!/bin/bash
set -e

# Setup env
export ANDROID_SDK_ROOT=$HOME/android-sdk
export ANDROID_NDK_HOME=$ANDROID_SDK_ROOT/ndk/25.2.9519653
export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"

# Clean env to prevent host compile flags
unset CPATH
unset CFLAGS
unset CXXFLAGS
unset LDFLAGS

# Build APK
p4a apk \
  --private . \
  --package=com.gtn.app \
  --name="Guess the Number" \
  --version=0.1 \
  --bootstrap=sdl2 \
  --requirements=python3,kivy \
  --arch=arm64-v8a \
  --sdk_dir=$ANDROID_HOME \
  --ndk_dir=$ANDROID_HOME/ndk/25.2.9519653 \
  --android_api=36 \
  --output "Guess the Number.apk"
