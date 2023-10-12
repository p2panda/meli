<h1 align="center">meli 🐝</h1>

<div align="center">
  <strong>Meli Android app built on top of p2panda</strong>
</div>

<div align="center">
  <h3>
    <a href="https://p2panda.org/about/contribute">
      Contribute
    </a>
    <span> | </span>
    <a href="https://p2panda.org">
      Website
    </a>
  </h3>
</div>

<br/>

This Android app is a collaborative database for sighting and categorisation of
[Meliponini](https://en.wikipedia.org/wiki/Stingless_bee) bee species in the
Brazilian Amazon. This project is a collaboration between
[p2panda](https://p2panda.org/) and [Meli](https://www.meli-bees.org/). The app
runs a full p2panda node and allows decentralised and offline-first
collaboration among users, it is developed with Flutter and uses the p2panda
SDK for its p2p functionalities.

## Development

This is a [Melos](https://melos.invertase.dev) mono-repository managing both
the Android application source-code and "external" Dart and Flutter libraries
providing all p2panda functionality via FFI bindings.

### Requirements

> Listed versions are the ones we used successfully in our developer
> environments, other versions might work well too.

* [Rust](https://www.rust-lang.org/tools/install) `1.70.0`
* [Android SDK](https://developer.android.com/tools) `34.0.0`
* [Android NDK](https://developer.android.com/ndk/) `25.2.9519653`
* [Flutter SDK](https://docs.flutter.dev/get-started/install) `3.10.5` and Dart SDK `3.0.5`
* [Melos](https://melos.invertase.dev/getting-started)

### Setup

```bash
# Install all Dart dependencies, make sure you've installed melos globally
dart pub get

# Bootstrap your Melos environment
melos bs
```

### Code-Checks

```bash
# Check code style and correctness
melos analyze

# Format code according to guidelines
melos format
```

### FFI packages

To bring [`p2panda-rs`] and [`aquadoggo`] into a native Android environment
we're utilising [`flutter_rust_bridge`] which automatically generates Dart code
with FFI bindings from Rust.

The code resides in:

* [`packages/p2panda/native`](packages/p2panda/native): Rust API used in the Android application
* [`packages/p2panda`](packages/p2panda): p2panda Dart package
* [`packages/p2panda_flutter`](packages/p2panda_flutter): p2panda Flutter package

Use the following commands for FFI package development:

```bash
# After changing the Rust code in `packages/p2panda/native` re-build the
# library. This automatically installs Android compilation targets and the
# cargo-ndk tool if missing.
#
# Additionally this script moves the native android libraries into the `app`
# folder, where they are needed.
melos build

# Bump the package versions for release (we're not releasing yet).
melos version
```

### Flutter App

It is recommended to develop or run the project with [Android
Studio](https://developer.android.com/studio) or with the [`flutter-cli`]
command line tool.

* [`packages/app`](packages/app): Android application built with Flutter

Here are some examples on how to run the app using the Flutter command line tool:

```bash
# Manage emulators
flutter emulators

# Launch an emulator
flutter emulators --launch <id>

# List all device ids (emulated or physical)
flutter devices

# Run app on emulated or connected device
flutter run --device-id <id>
```

### Relay Node

To configure your app to connect to a relay node you will need to set `RELAY_ADDRESS` with the 
correct ipv4 address and port number via an environment variable or the command line like so.

```bash
flutter run --dart-define=RELAY_ADDRESS=203.0.113.0:2022
```

As of the time of writing this functionality is not supported by emulated devices. We recommend only
enabling when running on hardware devices.

### Schema

The p2panda schemas and migrations are managed in the `schemas` folder with the
[`fishy`] command line tool.

* [`schemas`](schemas): Meli Schemas

## License

GNU Affero General Public License v3.0 [`AGPL-3.0-or-later`](LICENSE)

## Supported by

<img src="https://raw.githubusercontent.com/p2panda/.github/main/assets/ngi-logo.png" width="auto" height="80px"><br />
<img src="https://raw.githubusercontent.com/p2panda/.github/main/assets/nlnet-logo.svg" width="auto" height="80px"><br />
<img src="https://raw.githubusercontent.com/p2panda/.github/main/assets/eu-flag-logo.png" width="auto" height="80px">

*This project has received funding from the European Union’s Horizon 2020
research and innovation programme within the framework of the NGI-POINTER
Project funded under grant agreement No 871528*

[`aquadoggo`]: https://github.com/p2panda/aquadoggo

[`fishy`]: https://github.com/p2panda/fishy

[`flutter-cli`]: https://docs.flutter.dev/reference/flutter-cli

[`flutter_rust_bridge`]: https://github.com/fzyzcjy/flutter_rust_bridge

[`p2panda-rs`]: https://github.com/p2panda/p2panda

[`p2panda`]: https://p2panda.org
