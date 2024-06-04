#!/usr/bin/env bash

set -e

FLAVOR=normal
DEBUG_INFO_PATH=./build/app/outputs/flutter-apk

echo "◆ Clean up previous builds"
echo

cd ./packages/app
rm -rf ./build/app/outputs/flutter-apk

echo "◆ Build multiple .apk files per architecture"
echo

flutter build apk \
  --release \
  --flavor $FLAVOR \
  --split-per-abi \
  --obfuscate \
  --split-debug-info $DEBUG_INFO_PATH

echo
echo "◆ Build combined .apk file for all architectures"
echo

flutter build apk \
  --release \
  --flavor $FLAVOR \
  --obfuscate \
  --split-debug-info $DEBUG_INFO_PATH
