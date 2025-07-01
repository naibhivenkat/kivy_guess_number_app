#!/bin/bash
set -e

echo "== Installing dependencies =="
apt-get update
apt-get install -y zip unzip openjdk-17-jdk wget git \
  python3-dev clang cmake libffi-dev libssl-dev libgl1-mesa-dev \
  autoconf automake libtool m4 texinfo pkg-config curl

pip install --upgrade pip
pip install Cython==0.29.36
pip install git+https://github.com/kivy/python-for-android@develop

export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export ANDROID_NDK_HOME=$ANDROID_SDK_ROOT/ndk/25.2.9519653

echo "== Setting up Android SDK =="
mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
curl -sSL https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -o sdk-tools.zip
unzip -q sdk-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools
mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest

yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --licenses

$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager \
  "platform-tools" \
  "platforms;android-34" \
  "build-tools;36.0.0" \
  "ndk;25.2.9519653"

echo "== Building APK =="
python3 -m pythonforandroid.toolchain apk \
  --private /app \
  --package=com.gtn.app \
  --name="Guess the Number" \
  --version=0.1 \
  --bootstrap=sdl2 \
  --requirements=python3,kivy \
  --arch=arm64-v8a \
  --dist_name=guessnumber_dist \
  --android_api=34 \
  --sdk_dir=$ANDROID_SDK_ROOT \
  --ndk_dir=$ANDROID_NDK_HOME \
  --no-byte-compile-python

echo "== Locating generated APK =="
APK_PATH=$(find ~/.local/share/python-for-android/dists/guessnumber_dist/ -name "*.apk" | head -n 1)

if [[ -f "$APK_PATH" ]]; then
  echo "✅ APK built at $APK_PATH"
  cp "$APK_PATH" /output/Guess_the_Number.apk
else
  echo "❌ APK not found!"
  exit 1
fi
