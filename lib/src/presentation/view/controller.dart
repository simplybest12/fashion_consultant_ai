import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/file_picker.dart';

class ImageController extends GetxController {
  var imageFile = Rx<File?>(null);
  var error = false.obs;

  var occasion = ''.obs;

  void setOccasion(String label, bool selected) {
    occasion.value = selected ? label : '';
  }

  void selectImage() async {
    final FilePickerResult? res = await pickImage();
    if (res != null) {
      imageFile.value = File(res.files.single.path!);
      print("Loaded Image");
      print(imageFile.value);
      error.value = false;
    }
  }
}
