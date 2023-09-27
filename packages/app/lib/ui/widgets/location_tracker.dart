// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:app/io/geolocation.dart';

class LocationTracker extends StatefulWidget {
  LocationTracker({super.key});

  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  StreamController<Position> streamController = new StreamController();

  @override
  void initState() {
    super.initState();

    _initStream() async {
      try {
        // Attempt access to geolocation API of device
        final positionStream = await trackPosition();

        // Establish an async stream of position data coming in
        streamController.addStream(positionStream);
      } catch (error) {
        print(error);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Location Tracker Test'),
      StreamBuilder(
          stream: this.streamController.stream,
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
            if (snapshot.hasError) {
              return Text('Error');
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('State = None');
                case ConnectionState.waiting:
                  return Text('State = Waiting');
                case ConnectionState.active:
                  final latitude = snapshot.data!.latitude;
                  final longitude = snapshot.data!.longitude;
                  return Text('State = Active $latitude $longitude');
                case ConnectionState.done:
                  return Text('State = Done');
              }
            }
          }),
    ]);
  }
}
