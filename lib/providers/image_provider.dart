import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_cropper/image_cropper.dart';

class SelectImg extends ChangeNotifier {
  String? imagePath = "";
  final ImagePicker _picker = ImagePicker();
  ImageCropper crop = ImageCropper();

  late File img;

  pikeImage() async {
    final photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxHeight: 900,
        maxWidth: 600);
    if (photo != null) {
      img = File(photo.path);
      print(img.lengthSync());
      imagePath = photo.path;
    }

    lowImgQuality(img, imagePath!);
    print(img.lengthSync());
    notifyListeners();
  }

  cropFile() async {
    try {
      File? croppedFile = await crop.cropImage(
          sourcePath: imagePath!,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: const AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: const IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

      img = croppedFile ?? img;
      print(img.lengthSync());
      notifyListeners();
    } catch (e) {}
  }

  Future<File> lowImgQuality(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      imagePath!,
      imagePath! + '_img.jpg',
      quality: 50,
    );

    img = result!;
    notifyListeners();
    print(file.lengthSync());

    return result;
  }
}
