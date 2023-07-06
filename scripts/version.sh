#!/usr/bin/env bash

# Bumps the version number in the CMake script as well, so we're automatically
# downloading the latest version when installing the p2panda plugin in an
# Android environment (via Gradle).
#
# See: https://cjycode.com/flutter_rust_bridge/library/melos.html#scriptsversionsh

# Get current version from package
CURR_VERSION=p2panda-v`awk '/^version: /{print $2}' packages/p2panda/pubspec.yaml`

# Insert it in CMake script
CMAKE_HEADER="set(MimirVersion \"$CURR_VERSION\") # generated; do not edit"
sed -i.bak "1 s/.*/$CMAKE_HEADER/" packages/p2panda_flutter/android/CMakeLists.txt
rm packages/p2panda_flutter/android/*.bak

# Make git aware of that change
git add packages/p2panda_flutter
