use std::env;

// The new NDK doesn't link to `libgcc` anymore, which breaks our our libraries since they depended
// on the symbols from libclang_rt.builtins-x86_64-android` like `__extenddftf2`. See
// https://github.com/bbqsrc/cargo-ndk/issues/94 for details.
//
// The change works around this by manually linking to the libclang_rt.builtins-x86_64-android
// library in this case.
fn main() {
    let target_arch = env::var("CARGO_CFG_TARGET_ARCH").unwrap();
    let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap();

    if target_arch == "x86_64" && target_os == "android" {
        let android_home = env::var("ANDROID_HOME").expect("ANDROID_HOME not set");
        const ANDROID_NDK_VERSION: &str = "25.2.9519653";
        const LINUX_X86_64_LIB_DIR: &str =
            "/toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/14.0.7/lib/linux/";
        println!("cargo:rustc-link-search={android_home}/ndk/{ANDROID_NDK_VERSION}/{LINUX_X86_64_LIB_DIR}");
        println!("cargo:rustc-link-lib=static=clang_rt.builtins-x86_64-android");
    }
}
