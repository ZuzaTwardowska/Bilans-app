import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStorageComponents {
  static Future uploadImageToFirebase(
      BuildContext context, File file, String fileName) async {
    FirebaseStorage.instance
        .ref()
        .child('expensePhotos/$fileName')
        .putFile(file);
  }
}
