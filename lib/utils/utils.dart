import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(
    source: source,
  );
  if (_file != null) {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: _file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 500,
      aspectRatioPresets: [CropAspectRatioPreset.square],
    );

    Uint8List? croppedAndCompressedImage = await FlutterImageCompress.compressWithFile(
      croppedImage!.path,
      quality: 10
    );

    return croppedAndCompressedImage;
    // return croppedImage!.readAsBytes();
  }
  print('No image selected');
}

showSnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
