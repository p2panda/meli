// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class MeliCameraProvider extends StatefulWidget {
  const MeliCameraProvider(this.child, {super.key});
  final Widget child;

  @override
  MeliCameraProviderState createState() => MeliCameraProviderState();
}

class MeliCameraProviderState extends State<MeliCameraProvider> {
  final _imagePicker = ImagePicker();
  String? _retrieveDataError;

  Future<File?> retrieveLostData() async {
    final LostDataResponse response = await _imagePicker.retrieveLostData();

    if (response.file != null) {
      return File(response.file!.path);
    } else if (response.exception != null) {
      _retrieveDataError = response.exception!.code;
      print('CameraProvider error: $_retrieveDataError');
    }

    return null;
  }

  // Pick photos from the gallery.
  Future<List<File>> pickFromGallery() async {
    List<XFile> imageFiles =
        await _imagePicker.pickMultiImage(imageQuality: 80);

    return imageFiles.map((file) {
      return File(file.path);
    }).toList();
  }

  // Capture a photo from the camera.
  Future<File?> capturePhoto() async {
    ImageSource source = ImageSource.camera;
    if (!_imagePicker.supportsImageSource(source)) {
      source = ImageSource.gallery;
    }

    XFile? imageFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear);

    if (imageFile != null) {
      return File(imageFile.path);
    } else {
      return null;
    }
  }

  Widget renderChildren() {
    return MeliCameraProviderInherited(state: this, child: widget.child);
  }

  @override
  Widget build(BuildContext context) {
    return MeliCameraProviderInherited(state: this, child: widget.child);
  }
}

class MeliCameraProviderInherited extends InheritedWidget {
  final MeliCameraProviderState state;

  const MeliCameraProviderInherited({
    super.key,
    required this.state,
    required super.child,
  });

  static MeliCameraProviderState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MeliCameraProviderInherited>()!
        .state;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
