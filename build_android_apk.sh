#!/bin/bash
set -e

echo "== Installing dependencies =="
apt-get update
apt-get install -y \
  openjdk-17-jdk libz-dev libncurses5 libstdc++6 \
  zip unzip wget git python3-dev clang cmake \
  libffi-dev libssl-dev libgl1-mesa-dev autoconf automake \
  libtool m4 texinfo pkg-config curl

# Set Java home
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH="$JAVA_HOME/bin:$PATH"

# Install Python tools
pip install --upgrade pip
pip install Cython==0.29.36
pip install git+https://github.com/kivy/python-for-android@develop

# Set Android environment variables
export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export ANDROID_NDK_HOME=$ANDROID_SDK_ROOT/ndk/25.2.9519653
export GRADLE_OPTS="-Xmx4g -Dorg.gradle.daemon=false"
export ORG_GRADLE_PROJECT_javaOpts="-Xmx4g"
export JAVA_TOOL_OPTIONS="-Xmx4g"

echo "== Setting up Android SDK =="
mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O sdk-tools.zip
unzip -q sdk-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools
mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest

yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --licenses
$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager \
  "platform-tools" \
  "platforms;android-34" \
  "build-tools;36.0.0" \
  "ndk;25.2.9519653"

echo "== Building APK =="
mkdir -p /output

python3 -m pythonforandroid.toolchain apk \
  --private . \
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

# Make sure gradlew is executable (fix common Gradle error)
chmod -R +x /root/.local/share/python-for-android/dists/guessnumber_dist

echo "== Locating generated APK =="
APK_PATH=$(find /root/.local/share/python-for-android/dists/guessnumber_dist/bin -name "*.apk" | head -n 1)

if [[ -f "$APK_PATH" ]]; then
  echo "== APK found: $APK_PATH"
  cp "$APK_PATH" /output/Guess_the_Number.apk
  echo "✅ APK copied to /output/Guess_the_Number.apk"
else
  echo "❌ APK not found!"
  echo "== Checking Gradle logs =="
  ls -R /root/.local/share/python-for-android/dists/guessnumber_dist || true
  cat /root/.local/share/python-for-android/dists/guessnumber_dist/build.gradle || true
  exit 1
fi
