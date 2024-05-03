#!/usr/bin/env bash

set -e

BUILD_DIR=platform-build
JNI_DIR=jniLibs
APP_DIR=../packages/p2panda_flutter/android/src/main

# Generate FFI bindings from Rust and build native libraries for Android.

echo "◆ Install Rust toolchain dependencies"
echo

# Set up required Cargo toolbelt applications and Android compilation targets
cargo install cargo-ndk
cargo install cargo-expand
cargo install flutter_rust_bridge_codegen
rustup target add \
        aarch64-linux-android \
        armv7-linux-androideabi \
        x86_64-linux-android \
        i686-linux-android

echo "◆ Generate FFI bindings"
echo

# See: https://cjycode.com/flutter_rust_bridge/integrate/deps.html#system-dependencies
# CPATH="$(clang -v 2>&1 | grep "Selected GCC installation" | rev | cut -d' ' -f1 | rev)/include" \
flutter_rust_bridge_codegen \
        --inline-rust \
        --skip-add-mod-to-lib \
        --rust-input packages/p2panda/native/src/api.rs \
        --dart-output packages/p2panda/lib/src/bridge_generated.dart

echo
echo "◆ Create folders"
echo

mkdir -p $BUILD_DIR
cd $BUILD_DIR
mkdir -p $JNI_DIR

echo "◆ Build project"
echo

# Build the android libraries in the jniLibs directory
cargo ndk -o $JNI_DIR \
        --manifest-path ../packages/p2panda/native/Cargo.toml \
        -t armeabi-v7a \
        -t arm64-v8a \
        -t x86 \
        -t x86_64 \
        build --release

echo "◆ Publish libraries"
echo

# Move libraries into plugin folder
cp -fvR $JNI_DIR $APP_DIR

# Cleanup
rm -rf $JNI_DIR
