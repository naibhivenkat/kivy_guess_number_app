FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:/opt/ant/bin:$PATH"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git zip unzip openjdk-17-jdk curl wget \
    python3-dev build-essential \
    libffi-dev libssl-dev libgl1-mesa-dev \
    libsqlite3-dev zlib1g-dev \
    libjpeg-dev libfreetype6-dev \
    clang cmake \
    autoconf automake libtool pkg-config m4 texinfo && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir buildozer cython==0.29.36 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Apache ANT to avoid network issues during build
RUN mkdir -p /opt/ant && \
    curl -sSL https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.4-bin.tar.gz | tar -xz -C /opt/ant --strip-components=1

# Install Android SDK tools + accept licenses
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    curl -o sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip sdk-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager \
        "platform-tools" \
        "platforms;android-34" \
        "build-tools;36.0.0"

# Create non-root user and fix permission issues
RUN useradd -ms /bin/bash builder && \
    mkdir -p /home/builder/.buildozer && \
    chown -R builder:builder /home/builder/.buildozer


USER builder

# 🧩 Manually accept licenses where Buildozer installs the SDK
RUN mkdir -p /home/builder/.buildozer/android/platform/android-sdk/licenses && \
    echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > /home/builder/.buildozer/android/platform/android-sdk/licenses/android-sdk-license && \
    echo "d56f5187479451eabf01fb78af6dfcb131a6481e" >> /home/builder/.buildozer/android/platform/android-sdk/licenses/android-sdk-license && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > /home/builder/.buildozer/android/platform/android-sdk/licenses/android-sdk-preview-license

WORKDIR /home/builder/app
