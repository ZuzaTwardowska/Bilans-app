import 'dart:io';
import 'package:bilans/components/firebase_storage_components.dart';
import 'package:bilans/models/user_model.dart';
import 'package:bilans/utility/numeric_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DatabaseComponents {
  static void addCategory(
      GlobalKey<FormState> formKey,
      BuildContext context,
      UserModel loggedInUser,
      List<TextEditingController> controllers,
      String? selectedValue,
      DateTime? selectedDate,
      File? file) async {
    if (selectedValue == null || !formKey.currentState!.validate()) return;
    await FirebaseFirestore.instance
        .collection('categories')
        .add({
          'name': controllers[0].text,
          'description': controllers[1].text,
          'userId': loggedInUser.uid,
          'type': selectedValue,
          'id': FirebaseFirestore.instance.collection('categories').doc().id,
        })
        .then((value) => Fluttertoast.showToast(msg: "Category added!"))
        .catchError(
            (error) => Fluttertoast.showToast(msg: "Something went wrong..."));
    Navigator.of(context).pop();
  }

  static void addExpense(
      GlobalKey<FormState> formKey,
      BuildContext context,
      UserModel loggedInUser,
      List<TextEditingController> controllers,
      String? selectedValue,
      DateTime? selectedDate,
      File? file) async {
    if (selectedValue == null ||
        !formKey.currentState!.validate() ||
        selectedDate == null) {
      Fluttertoast.showToast(msg: "Provide all data!");
      return;
    }
    String id = FirebaseFirestore.instance.collection('expenses').doc().id;
    await FirebaseFirestore.instance
        .collection('expenses')
        .add({
          'name': controllers[0].text,
          'description': controllers[1].text,
          'amount': Numeric.formatPrice(controllers[2].text),
          'userId': loggedInUser.uid,
          'categoryId': selectedValue,
          'date': selectedDate,
          'id': id,
        })
        .then((value) => {
              if (file != null)
                {
                  FirebaseStorageComponents.uploadImageToFirebase(
                      context, file, id)
                },
              Fluttertoast.showToast(msg: "Expense added!")
            })
        .catchError(
            (error) => Fluttertoast.showToast(msg: "Something went wrong..."));
    Navigator.of(context).pop();
  }

  static void addIncome(
      GlobalKey<FormState> formKey,
      BuildContext context,
      UserModel loggedInUser,
      List<TextEditingController> controllers,
      String? selectedValue,
      DateTime? selectedDate,
      File? file) async {
    if (selectedValue == null ||
        !formKey.currentState!.validate() ||
        selectedDate == null) {
      Fluttertoast.showToast(msg: "Provide all data!");
      return;
    }
    await FirebaseFirestore.instance
        .collection('incomes')
        .add({
          'name': controllers[0].text,
          'description': controllers[1].text,
          'amount': Numeric.formatPrice(controllers[2].text),
          'userId': loggedInUser.uid,
          'categoryId': selectedValue,
          'date': selectedDate,
          'id': FirebaseFirestore.instance.collection('incomes').doc().id,
        })
        .then((value) => Fluttertoast.showToast(msg: "Income added!"))
        .catchError(
            (error) => Fluttertoast.showToast(msg: "Something went wrong..."));
    Navigator.of(context).pop();
  }
}
