#!/bin/bash
set -e

apt-get update
apt-get install -y zip unzip openjdk-17-jdk wget git \
  python3-dev clang cmake libffi-dev libssl-dev libgl1-mesa-dev \
  autoconf automake libtool m4 texinfo

pip install --upgrade pip
pip install Cython==0.29.36 python-for-android==2024.1.21

export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_NDK_HOME=$ANDROID_SDK_ROOT/ndk/25.2.9519653

mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O sdk-tools.zip
unzip sdk-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools
mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest

yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --licenses
$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager \
  'platform-tools' \
  'platforms;android-34' \
  'build-tools;36.0.0' \
  'ndk;25.2.9519653'

python3 -m pythonforandroid.toolchain apk \
  --private . \
  --package=com.gtn.app \
  --name="Guess the Number" \
  --version=0.1 \
  --bootstrap=sdl2 \
  --requirements=python3,kivy \
  --arch=arm64-v8a \
  --android_api=34 \
  --sdk_dir=$ANDROID_SDK_ROOT \
  --ndk_dir=$ANDROID_NDK_HOME \
  --output=Guess_the_Number.apk
