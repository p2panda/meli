// SPDX-License-Identifier: AGPL-3.0-or-later

use std::env;

/// Pinned NDK version, needs to be installed on machine.
const ANDROID_NDK_VERSION: &'static str = "25.2.9519653";

fn main() {
    let target_arch = env::var("CARGO_CFG_TARGET_ARCH").unwrap();
    let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap();

    let host_os_prefix = if env::consts::OS == "macos" {
        "darwin"
    } else {
        "linux"
    };

    // x86-64 linux standard library path inside NDK directory.
    let linux_x86_64_lib_dir = std::format!(
        "/toolchains/llvm/prebuilt/{host_os_prefix}-x86_64/lib64/clang/14.0.7/lib/linux/"
    );

    // The new NDK doesn't link to `libgcc` anymore, which breaks our our libraries since they
    // depended on the symbols from `libclang_rt.builtins-x86_64-android` like `__extenddftf2`. See
    // https://github.com/bbqsrc/cargo-ndk/issues/94 for details.
    //
    // The change works around this by manually linking to the
    // `libclang_rt.builtins-x86_64-android` library in this case.
    if target_arch == "x86_64" && target_os == "android" {
        let android_home = env::var("ANDROID_HOME").expect("ANDROID_HOME not set");
        println!("cargo:rustc-link-search={android_home}/ndk/{ANDROID_NDK_VERSION}/{linux_x86_64_lib_dir}");
        println!("cargo:rustc-link-lib=static=clang_rt.builtins-x86_64-android");
    }
}
