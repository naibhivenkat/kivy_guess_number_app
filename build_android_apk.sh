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

# Install and prepare kivy from source to avoid .c errors
pip install "cython==0.29.36"
git clone --depth 1 https://github.com/kivy/kivy.git
cd kivy
python setup.py build_ext --inplace
cd ..

# Build APK
p4a apk \
  --private . \
  --package "com.example.guessthenumber" \
  --name "Guess the Number" \
  --version "1.0" \
  --bootstrap sdl2 \
  --requirements "./kivy" \
  --android-api 33 \
  --arch "arm64-v8a" \
  --output "Guess the Number.apk" \
  --release \
  --permission INTERNET \
  --copy-libs \
  --sdk-dir "$ANDROID_SDK_ROOT" \
  --ndk-dir "$ANDROID_NDK_HOME" \
  --verbose
