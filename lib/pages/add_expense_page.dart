import 'package:bilans/components/form_field_components.dart';
import 'package:bilans/models/category_model.dart';
import 'package:bilans/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({Key? key}) : super(key: key);

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  String? selectedCategory;
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
    CollectionReference categories =
        FirebaseFirestore.instance.collection('categories');
    CollectionReference expenses =
        FirebaseFirestore.instance.collection('expenses');

    final nameField = FormFieldComponents.regularTextField(
        nameController, "Expense title", true, Icons.category_rounded);

    final descriptionField = FormFieldComponents.regularTextField(
        descriptionController,
        "Expense Description",
        false,
        Icons.description_rounded);

    final amountField =
        FormFieldComponents.amountTextField(amountController, "Cost");

    final categoryField = FormFieldComponents.dropdownCategoryListField(
        categories
            .where("userId", isEqualTo: loggedInUser.uid)
            .where("type", isEqualTo: "Expense Category")
            .snapshots(),
        selectedCategory,
        setCategory);

    final addButton = FormFieldComponents.addNewElement(
        context, expenses, addExpense, "Add Expense");

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
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 80),
                nameField,
                const SizedBox(height: 20),
                descriptionField,
                const SizedBox(height: 20),
                categoryField,
                const SizedBox(height: 20),
                amountField,
                const SizedBox(height: 40),
                addButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addExpense(CollectionReference expenses) async {
    if (selectedCategory == null || !_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Provide all data!");
      return;
    }
    await expenses
        .add({
          'name': nameController.text,
          'description': descriptionController.text,
          'amount': amountController.text,
          'userId': loggedInUser.uid,
          'categoryId': selectedCategory,
          'id': expenses.doc().id,
        })
        .then((value) => Fluttertoast.showToast(msg: "Expense added!"))
        .catchError(
            (error) => Fluttertoast.showToast(msg: "Something went wrong..."));
    Navigator.of(context).pop();
  }

  void setCategory(String value) {
    setState(() {
      selectedCategory = value;
    });
  }
}
