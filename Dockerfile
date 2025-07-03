FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_SDK_ROOT=/opt/android-sdk

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git zip unzip openjdk-17-jdk wget curl \
    python3-dev build-essential \
    libffi-dev libssl-dev libgl1-mesa-dev \
    libsqlite3-dev zlib1g-dev \
    libjpeg-dev libfreetype6-dev \
    clang cmake \
    autoconf automake libtool pkg-config m4 texinfo && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir buildozer cython==0.29.36 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Android SDK and accept licenses
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    curl -o sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip sdk-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager \
        "platform-tools" \
        "platforms;android-34" \
        "build-tools;36.0.0"

ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}"

# Create non-root user
RUN useradd -ms /bin/bash builder
USER builder

WORKDIR /home/builder/app