import 'package:flutter/material.dart';

class FormValidator {
  static String? isEmailFieldValid(String value) {
    if (value.isEmpty) {
      return ("Please enter Your email.");
    }
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
      return ("Please enter a valid email.");
    }
    return null;
  }

  static String? isPasswordFieldValid(String value) {
    if (value.isEmpty) {
      return ("Password is required.");
    }
    if (!RegExp(r'^.{6,}$').hasMatch(value)) {
      return ("Enter valid password(min. 6 characters).");
    }
    return null;
  }

  static String? isConfirmPasswordFieldValid(String value, String password) {
    if (value != password) {
      return "Passwords don't match.";
    }
    return null;
  }

  static String? isRegularTextFieldValid(
      String value, String name, bool validate) {
    if (!validate) return null;
    if (value.isEmpty) {
      return (name + " cannot be empty.");
    }
    if (!RegExp(r'^.{3,}$').hasMatch(value)) {
      return ("Enter valid value(min. 3 characters).");
    }
    return null;
  }

  static String? isAmountTextFieldValid(String value) {
    if (value.isEmpty) {
      return ("Provide cost");
    }
    try {
      final number = double.parse(value);
      if (value.contains(',')) return ("Use '.' for decimals.");
      if (!value.contains('.')) return null;
      if (value.substring(value.indexOf('.')).length > 2) {
        return ("Provide valid decimal");
      }
      return null;
    } catch (e) {
      return ("Provide valid decimal");
    }
  }
}
