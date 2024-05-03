// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:geolocator/geolocator.dart';

/// Throw exception after waiting for x seconds.
const TIMEOUT_DURATION = Duration(seconds: 30);

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions are denied the
/// `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue accessing the position
    // and request users of the App to enable the location services.
    throw const LocationServiceDisabledException();
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try requesting permissions
      // again (this is also where Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines your App should show an
      // explanatory UI now.
      throw const PermissionDeniedException('Permission was denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    throw const PermissionDeniedException('Permission is permamently denied');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(timeLimit: TIMEOUT_DURATION);
}
