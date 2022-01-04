import 'package:bilans/components/database_components.dart';
import 'package:bilans/components/form_field_components.dart';
import 'package:bilans/components/page_components.dart';
import 'package:bilans/models/user_model.dart';
import 'package:flutter/material.dart';

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
  String selectedType = "Income Category";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nameField = FormFieldComponents.regularTextField(nameController,
        "Category Name", true, Icons.category_rounded, TextInputAction.next);

    final descriptionField = FormFieldComponents.regularTextField(
        descriptionController,
        "Category Description",
        false,
        Icons.description_rounded,
        TextInputAction.next);

    final typeField = PageComponents.dropdownOptions(
        selectedType,
        (String value) => {selectedType = value},
        ["Income Category", "Expense Category"]);

    final addButton = FormFieldComponents.addNewElement(
        context,
        DatabaseComponents.addCategory,
        "Add Category",
        _formKey,
        widget.loggedInUser,
        [nameController, descriptionController],
        selectedType,
        null,
        null);

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
}
