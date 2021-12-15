import 'package:bilans/models/category_model.dart';
import 'package:bilans/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();
  final nameEditingController = TextEditingController();
  final descriptionEditingController = TextEditingController();
  var _currentSelectedValue;

  final _auth = FirebaseAuth.instance;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference categories =
    //     FirebaseFirestore.instance.collection('categories');

    final nameField = TextFormField(
      autofocus: false,
      controller: nameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Category Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.category_rounded),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Category Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final descriptionField = TextFormField(
      autofocus: false,
      controller: descriptionEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        return null;
      },
      onSaved: (value) {
        descriptionEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.description_rounded),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Category Description",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final typeField = FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            hintText: "Select category type",
            errorStyle:
                const TextStyle(color: Colors.redAccent, fontSize: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          isEmpty: _currentSelectedValue == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _currentSelectedValue,
              isDense: true,
              onChanged: (String? newValue) {
                setState(
                  () {
                    _currentSelectedValue = newValue!;
                    state.didChange(newValue);
                  },
                );
              },
              items:
                  ["Income Category", "Expense Category"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          // categories
          //     .add({
          //       'name': nameEditingController.value,
          //       'description': descriptionEditingController.value,
          //       'userId': loggedInUser.uid,
          //     })
          //     .then((value) => {})
          //     .catchError((error) => {});
        },
        child: const Text(
          "Add Category",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 120),
                nameField,
                const SizedBox(height: 20),
                descriptionField,
                const SizedBox(height: 20),
                typeField,
                const SizedBox(height: 40),
                addButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
