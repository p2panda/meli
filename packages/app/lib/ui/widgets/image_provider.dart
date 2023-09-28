// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MeliCameraProvider extends StatefulWidget {
  const MeliCameraProvider(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  MeliCameraProviderState createState() => MeliCameraProviderState();
}

class MeliCameraProviderState extends State<MeliCameraProvider> {
  final _imagePicker = ImagePicker();
  bool _initialImagePickAttemptComplete = false;
  String? _retrieveDataError;
  List<File> images = [];

  List<File> getAll() {
    return images;
  }

  bool isEmpty() {
    return (images.length == 0);
  }

  void addAll(List<File> newImages) {
    setState(() {
      newImages.addAll(images);
      images = newImages;
    });
  }

  void removeAt(int index) {
    setState(() {
      List<File> newImages = [];
      newImages.addAll(images);
      newImages.removeAt(index);
      images = newImages;
    });
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      addAll([File(response.file!.path)]);
    } else {
      _retrieveDataError = response.exception!.code;
      print('CameraProvider error: ${_retrieveDataError}');
    }
  }

  // Pick photos from the gallery.
  Future<void> pickFromGallery() async {
    List<XFile> imageFiles =
        await _imagePicker.pickMultiImage(imageQuality: 50);

    addAll(imageFiles.map((file) {
      return File(file.path);
    }).toList());
  }

  // Capture a photo from the camera.
  Future<void> capturePhoto() async {
    ImageSource source = ImageSource.camera;
    if (!_imagePicker.supportsImageSource(source)) {
      print('Camera source not supported');
      source = ImageSource.gallery;
    }

    XFile? imageFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);

    if (imageFile != null) {
      addAll([File(imageFile.path)]);
    }
  }

  Widget renderChildren() {
    return MeliCameraProviderInherited(
        images: images, state: this, child: this.widget.child);
  }

  @override
  Widget build(BuildContext context) {
    // Trigger this on every build, if there is lost data it will add it back to
    // the provider.
    retrieveLostData();

    // Check if we already attempted to pick an initial image, immediately return
    // the child wrapped in the image provider if so.
    if (_initialImagePickAttemptComplete) {
      return MeliCameraProviderInherited(
          images: images, state: this, child: this.widget.child);
    }

    // On initial build we want to go straight to the camera so the user can choose
    // an image before being shown child widget.
    return FutureBuilder(
        // Trigger capturing a photo, this displays the camera view.
        future: capturePhoto(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('ImageProvider Error: ${snapshot.error}');
            return renderChildren();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return renderChildren();
          }

          _initialImagePickAttemptComplete = true;
          return Container(color: Colors.black);
        });
  }
}

class MeliCameraProviderInherited extends InheritedWidget {
  final List<File> images;
  final MeliCameraProviderState state;

  MeliCameraProviderInherited({
    Key? key,
    required List<File> this.images,
    required MeliCameraProviderState this.state,
    required Widget child,
  }) : super(key: key, child: child);

  static MeliCameraProviderState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MeliCameraProviderInherited>()!
        .state;
  }

  @override
  bool updateShouldNotify(MeliCameraProviderInherited oldWidget) {
    bool result = (images != oldWidget.images);
    print(result);
    return result;
  }
}
