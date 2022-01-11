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

  static Future<Image?> getImage(BuildContext context, String image) async {
    Image? m;
    var url =
        await FirebaseStorage.instance.ref().child(image).getDownloadURL();
    if (url == null) return null;
    m = Image.network(
      url.toString(),
      fit: BoxFit.scaleDown,
    );

    return m;
  }
}
