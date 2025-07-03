# Dockerfile
FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git zip unzip openjdk-17-jdk \
    python3-dev build-essential \
    libffi-dev libssl-dev libgl1-mesa-dev \
    libsqlite3-dev zlib1g-dev \
    libjpeg-dev libfreetype6-dev \
    clang cmake \
    autoconf automake libtool pkg-config m4 texinfo \
    wget && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir buildozer cython==0.29.36 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Pre-download SDK tools to speed up
RUN mkdir -p ~/.buildozer

WORKDIR /home/user/app
