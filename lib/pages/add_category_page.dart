import 'package:bilans/components/form_field_components.dart';
import 'package:bilans/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCategoryPage extends StatefulWidget {
  final UserModel loggedInUser;
  const AddCategoryPage({Key? key, required this.loggedInUser})
      : super(key: key);

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  String? selectedType;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference categories =
        FirebaseFirestore.instance.collection('categories');

    final nameField = FormFieldComponents.regularTextField(nameController,
        "Category Name", true, Icons.category_rounded, TextInputAction.next);

    final descriptionField = FormFieldComponents.regularTextField(
        descriptionController,
        "Category Description",
        false,
        Icons.description_rounded,
        TextInputAction.next);

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
          isEmpty: selectedType == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedType,
              isDense: true,
              onChanged: (String? newValue) {
                setState(
                  () {
                    selectedType = newValue!;
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

    final addButton = FormFieldComponents.addNewElement(
        context, categories, addCategory, "Add Category");

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 60),
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
      ),
    );
  }

  void addCategory(CollectionReference categories) async {
    if (selectedType == null) return;
    if (!_formKey.currentState!.validate()) return;
    await categories
        .add({
          'name': nameController.text,
          'description': descriptionController.text,
          'userId': widget.loggedInUser.uid,
          'type': selectedType,
          'id': categories.doc().id,
        })
        .then((value) => Fluttertoast.showToast(msg: "Category added!"))
        .catchError(
            (error) => Fluttertoast.showToast(msg: "Something went wrong..."));
    Navigator.of(context).pop();
  }
}
