#!/bin/bash
set -e

python3 -m pythonforandroid.toolchain create \
  --dist_name guess_game \
  --bootstrap sdl2 \
  --requirements kivy \
  --arch armeabi-v7a \
  --package org.example.guessgame \
  --name "Guess the Number" \
  --version 0.1 \
  --ndk-api 21 \
  --sdk-dir $ANDROID_SDK_ROOT \
  --ndk-dir $ANDROID_SDK_ROOT/ndk/25.2.9519653 \
  --output-dir dist

python3 -m pythonforandroid.toolchain apk \
  --dist_name guess_game \
  --arch armeabi-v7a \
  --output Guess\ the\ Number.apk
