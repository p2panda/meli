// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:geolocator/geolocator.dart';

/// Ignore updates when position has not changed for x meters.
const DISTANCE_FILTER_METERS = 5;

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions are denied the
/// `Future` will return an error.
Future<Stream<Position>> trackPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue accessing the position
    // and request users of the App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try requesting permissions
      // again (this is also where Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines your App should show an
      // explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: DISTANCE_FILTER_METERS,
  );

  return Geolocator.getPositionStream(locationSettings: locationSettings);
}
