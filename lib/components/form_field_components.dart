import 'package:bilans/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'form_validation.dart';
import 'package:intl/intl.dart';

class FormFieldComponents {
  static TextFormField emailField(
      TextEditingController emailController, TextInputAction inputAction) {
    return TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => FormValidator.isEmailFieldValid(value!),
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: inputAction,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  static TextFormField passwordField(
      TextEditingController passwordController, TextInputAction inputAction) {
    return TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => FormValidator.isPasswordFieldValid(value!),
      controller: passwordController,
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: inputAction,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  static TextFormField confrimPasswordField(
      TextEditingController passwordController,
      String passwordValue,
      TextInputAction inputAction) {
    return TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) =>
          FormValidator.isConfirmPasswordFieldValid(value!, passwordValue),
      controller: passwordController,
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: inputAction,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  static TextFormField regularTextField(TextEditingController controller,
      String name, bool validate, IconData icon, TextInputAction inputAction) {
    return TextFormField(
      autofocus: false,
      validator: (value) =>
          FormValidator.isRegularTextFieldValid(value!, name, validate),
      controller: controller,
      onSaved: (value) {
        controller.text = value!;
      },
      textInputAction: inputAction,
      decoration: InputDecoration(
          prefixIcon: Icon(icon),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: name,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  static TextFormField amountTextField(TextEditingController controller,
      String name, TextInputAction inputAction) {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.number,
      validator: (value) => FormValidator.isAmountTextFieldValid(value!),
      controller: controller,
      onSaved: (value) {
        controller.text = value!;
      },
      textInputAction: inputAction,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.attach_money),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: name,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  static TextButton dateField(
      BuildContext context, DateTime? dateController, Function setDate) {
    return TextButton(
      onPressed: () {
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(2010, 1, 1),
            maxTime: DateTime.now(),
            theme: const DatePickerTheme(
                headerColor: Colors.redAccent,
                backgroundColor: Colors.white,
                itemStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
            onConfirm: (date) {
          setDate(date);
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(
                Icons.date_range_outlined,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                dateController == null
                    ? "Date"
                    : DateFormat("dd-MM-yyyy").format(dateController),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Material formSubmitButton(BuildContext context, String name,
      List<TextEditingController> controllers, Function action) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          action(controllers);
        },
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Material addNewElement(BuildContext context,
      CollectionReference collection, Function action, String name) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          action(collection);
        },
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static StreamBuilder dropdownCategoryListField(
      Stream<QuerySnapshot> dataStream,
      String? selectedCategory,
      Function action) {
    return StreamBuilder<QuerySnapshot>(
        stream: dataStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isNotEmpty) {
            return Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      hintText: 'Choose category',
                    ),
                    isEmpty: selectedCategory == null,
                    child: DropdownButton(
                      value: selectedCategory,
                      isDense: true,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        action(newValue!);
                      },
                      items: snapshot.data!.docs.map((doc) {
                        return DropdownMenuItem<String>(
                          value: CategoryModel.fromMap(doc).id,
                          child: Text(CategoryModel.fromMap(doc).name!),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Text("Please add some categories first.");
          }
        });
  }
}
