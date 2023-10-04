// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';

import 'package:app/io/geolocation.dart';
import 'package:app/ui/widgets/button.dart';
import 'package:app/ui/widgets/simple_card.dart';

enum LocationTrackerStatus {
  Standby,
  Waiting,
  Active,
  Failure,
}

typedef LocationTrackerBuilder = Widget Function(
  Position? position,
  LocationTrackerStatus status, {
  String? errorMessage,
  VoidCallback? addLocation,
  VoidCallback? removeLocation,
});

class LocationTracker extends StatefulWidget {
  final ValueChanged<Position?>? onPositionChanged;
  final LocationTrackerBuilder builder;

  LocationTracker({super.key, required this.builder, this.onPositionChanged});

  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  /// Current position value which is exposed to other widgets.
  Position? _position;

  /// Current status of the position tracker.
  LocationTrackerStatus _status = LocationTrackerStatus.Standby;

  /// Keep track of the last known error.
  String? _errorMessage;

  Position? getPosition() {
    return this._position;
  }

  void _updatePosition(Position? value) {
    this._position = value;

    if (widget.onPositionChanged != null) {
      widget.onPositionChanged!.call(value);
    }
  }

  void _addLocation() async {
    final t = AppLocalizations.of(context)!;

    setState(() {
      this._status = LocationTrackerStatus.Waiting;
      this._errorMessage = null;
    });

    try {
      // Retrieve position from location service
      final position = await determinePosition();

      // Inform external widgets about the position or handle potential errors
      this._updatePosition(position);
      this._status = LocationTrackerStatus.Active;
    } on PermissionDeniedException {
      this._errorMessage = t.locationErrorPermissionDenied;
    } on LocationServiceDisabledException {
      this._errorMessage = t.locationErrorServiceDisabled;
    } on TimeoutException {
      this._errorMessage = t.locationErrorTimeout;
    } catch (error) {
      this._errorMessage = t.locationErrorUnknown;
    } finally {
      this._status = this._errorMessage != null
          ? LocationTrackerStatus.Failure
          : this._status;

      // Force refresh UI
      setState(() {});
    }
  }

  void _removeLocation() {
    setState(() {
      this._status = LocationTrackerStatus.Standby;
    });

    this._updatePosition(null);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(this._position, this._status,
        errorMessage: this._errorMessage,
        addLocation: this._addLocation,
        removeLocation: this._removeLocation);
  }
}

class LocationTrackerInput extends StatefulWidget {
  final ValueChanged<Position?>? onPositionChanged;

  LocationTrackerInput({super.key, this.onPositionChanged});

  @override
  State<LocationTrackerInput> createState() => _LocationTrackerInputState();
}

class _LocationTrackerInputState extends State<LocationTrackerInput> {
  final GlobalKey<_LocationTrackerState> _trackerKey = GlobalKey();

  /// User confirmed that they want to track their location. This does not have
  /// anything to do with the device's permission settings but merely with the
  /// user interface in the Meli app.
  bool _hasUserGivenConsent = false;

  Position? getPosition() {
    return this._trackerKey.currentState!.getPosition();
  }

  Widget _header(IconData icon, String text) {
    return Container(
        width: double.infinity,
        child: Column(
          children: [
            Icon(
              icon,
              size: 40.0,
              color: Colors.black,
            ),
            SizedBox(height: 10),
            Text(text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ));
  }

  Widget _standby(VoidCallback? addLocation) {
    final t = AppLocalizations.of(context)!;

    return Wrap(runSpacing: 10.0, alignment: WrapAlignment.center, children: [
      _header(Icons.location_searching, t.locationAdd),
      MeliIconButton(
          child: Text(t.locationAddAction),
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              _hasUserGivenConsent = true;
            });

            addLocation!();
          }),
    ]);
  }

  Widget _waiting() {
    final t = AppLocalizations.of(context)!;

    return Column(
      children: [
        SizedBox(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(
                color: Colors.black, strokeWidth: 3.0)),
        SizedBox(height: 15),
        Text(t.locationLoading, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _success(Position position, VoidCallback? removeLocation) {
    final t = AppLocalizations.of(context)!;

    final latitude = position.latitude;
    final longitude = position.longitude;

    return Wrap(runSpacing: 10.0, alignment: WrapAlignment.center, children: [
      _header(Icons.where_to_vote_rounded,
          t.locationSuccessful(latitude, longitude)),
      MeliIconButton(
          child: Text(t.locationRemoveAction),
          icon: Icon(Icons.remove),
          onPressed: () {
            setState(() {
              _hasUserGivenConsent = false;
            });

            removeLocation!();
          }),
    ]);
  }

  Widget _failed(String errorMessage, VoidCallback? addLocation) {
    final t = AppLocalizations.of(context)!;

    return Wrap(runSpacing: 10.0, alignment: WrapAlignment.center, children: [
      _header(Icons.wrong_location_rounded, errorMessage),
      Text(t.locationTryAgain, style: Theme.of(context).textTheme.bodyLarge),
      MeliIconButton(
          child: Text(t.locationTryAgainAction),
          icon: Icon(Icons.loop),
          onPressed: addLocation),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SimpleCard(
        title: t.locationHeader,
        child: LocationTracker(
            key: this._trackerKey,
            builder: (Position? position, LocationTrackerStatus status,
                {String? errorMessage,
                VoidCallback? addLocation,
                VoidCallback? removeLocation}) {
              if (!this._hasUserGivenConsent) {
                return this._standby(addLocation);
              }

              switch (status) {
                case LocationTrackerStatus.Standby:
                case LocationTrackerStatus.Waiting:
                  return this._waiting();
                case LocationTrackerStatus.Active:
                  return this._success(position!, removeLocation);
                case LocationTrackerStatus.Failure:
                  return this._failed(errorMessage!, addLocation);
              }
            },
            onPositionChanged: (Position? value) {
              if (widget.onPositionChanged != null) {
                widget.onPositionChanged!.call(value);
              }
            }));
  }
}
