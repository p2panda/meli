import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File> getImage(ImageSource source) async {
  ImagePicker imagePicker = new ImagePicker();
  XFile image = await imagePicker.pickImage(
      source: source,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.front) as XFile;
  return File(image.path);
}
