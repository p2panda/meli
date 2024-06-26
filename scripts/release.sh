#!/usr/bin/env bash

set -e

FLAVOR=${FLAVOR:-normal}
TARGET_DIR=./build/app/outputs/flutter-apk

version=$(grep 'version:' ./packages/app/pubspec.yaml | awk '{ print $2 }')

echo "◆ Clean up previous builds"
echo

cd ./packages/app
rm -rf ./build/app/outputs/flutter-apk

echo "◆ Build multiple .apk files per architecture"
echo

flutter build apk \
  --dart-define=RELAY_ADDRESS=$RELAY_ADDRESS \
  --release \
  --flavor $FLAVOR \
  --split-per-abi \
  --obfuscate \
  --split-debug-info $TARGET_DIR

echo
echo "◆ Build combined .apk file for all architectures"
echo

flutter build apk \
  --dart-define=RELAY_ADDRESS=$RELAY_ADDRESS \
  --release \
  --flavor $FLAVOR \
  --obfuscate \
  --split-debug-info $TARGET_DIR

echo
echo "◆ Give files nice names"
echo

cd $TARGET_DIR

for file in *.apk*; do
  new_file=$(echo "$file" | sed "s/app/meli/")
  new_file=$(echo "$new_file" | sed "s/$FLAVOR/$FLAVOR-$version/")
  new_file=$(echo "$new_file" | sed "s/\+/-/")
  mv $file $new_file
  echo "- $new_file"
done
