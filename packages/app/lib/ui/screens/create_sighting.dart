// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:app/ui/widgets/autocomplete.dart';
import 'package:app/ui/widgets/local_name_autocomplete.dart';
import 'package:app/ui/widgets/simple_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:app/models/sightings.dart';
import 'package:app/router.dart';
import 'package:app/ui/widgets/fab.dart';
import 'package:app/ui/widgets/location_tracker.dart';
import 'package:app/ui/widgets/scaffold.dart';

class CreateNewScreen extends StatefulWidget {
  CreateNewScreen({super.key});

  @override
  State<CreateNewScreen> createState() => _CreateNewScreenState();
}

class _CreateNewScreenState extends State<CreateNewScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameInput = TextEditingController();
  final _imagePicker = ImagePicker();
  String? _retrieveDataError;
  File? _image;

  void _setImage(XFile? image) {
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<XFile?> _getImage(ImageSource source) async {
    return await _imagePicker.pickImage(
        source: source,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _retrieveLostData() async {
    final LostDataResponse response =
        await this._imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _setImage(response.file);
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Widget _handlePreview() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_image != null) {
      return Container(
        height: 300,
        child: Image.file(
          _image!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _previewImage() {
    return defaultTargetPlatform == TargetPlatform.android
        ? FutureBuilder<void>(
            future: _retrieveLostData(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Text(
                    'You have not yet picked an image.',
                    textAlign: TextAlign.center,
                  );
                case ConnectionState.done:
                  return _handlePreview();
                case ConnectionState.active:
                  if (snapshot.hasError) {
                    return Text(
                      'Pick image/video error: ${snapshot.error}}',
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return const Text(
                      'You have not yet picked an image.',
                      textAlign: TextAlign.center,
                    );
                  }
              }
            },
          )
        : _handlePreview();
  }

  @override
  void initState() {
    super.initState();
    this._getImage(ImageSource.camera).then((image) => this._setImage(image));
  }

  @override
  void dispose() {
    nameInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: 'Create new',
        floatingActionButtons: [
          MeliFloatingActionButton(
              heroTag: 'create_new',
              icon: Icon(Icons.create),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Create sighting data
                  try {
                    // TODO: populate all fields from form
                    DateTime datetime = DateTime.now();
                    await createSighting(datetime, 0.0, 0.0, [], null, null,
                        "Some comment about this sighting");

                    // Go back to sightings overview
                    router.push(RoutePaths.allSightings.path);

                    // Show notification
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Yay! Created new sighting'),
                    ));
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Something went wrong: $err'),
                    ));
                  }
                }
              }),
        ],
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.only(
                  top: 0, right: 20.0, bottom: 75.0, left: 20.0),
              children: [
                SimpleCard(title: 'Local Name', child: LocalNameAutocomplete()),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () async {
                          XFile? image =
                              await this._getImage(ImageSource.gallery);
                          this._setImage(image);
                        }),
                    IconButton(
                      icon: Icon(Icons.photo_camera),
                      onPressed: () async {
                        XFile? image = await this._getImage(ImageSource.camera);
                        this._setImage(image);
                      },
                    ),
                  ],
                ),
                _previewImage(),
                SizedBox(height: 25.0),
                LocationTrackerInput(onPositionChanged: (position) {
                  if (position == null) {
                    print('Position: n/a');
                  } else {
                    print('Position: $position');
                  }
                }),
              ],
            )));
  }
}
