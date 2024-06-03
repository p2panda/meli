#!/usr/bin/env bash

set -e

cd ./packages/app

# Clean up old build artefacts
rm -rf ./build/app/outputs/flutter-apk

# Make a build per architecture
flutter build apk \
  --flavor normal \
  --split-per-abi \
  --release \
  --obfuscate \
  --split-debug-info ./build/app/outputs/flutter-apk

# Make a bundle for all architectures
flutter build apk \
  --flavor normal \
  --release \
  --obfuscate \
  --split-debug-info ./build/app/outputs/flutter-apk
