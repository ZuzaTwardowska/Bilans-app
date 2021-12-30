import 'package:bilans/components/form_field_components.dart';
import 'package:bilans/models/user_model.dart';
import 'package:bilans/utility/numeric_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddIncomePage extends StatefulWidget {
  final UserModel loggedInUser;
  const AddIncomePage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  String? selectedCategory;
  String? errorMessage;
  DateTime? dateControll;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference categories =
        FirebaseFirestore.instance.collection('categories');
    CollectionReference incomes =
        FirebaseFirestore.instance.collection('incomes');

    final nameField = FormFieldComponents.regularTextField(nameController,
        "Income title", true, Icons.category_rounded, TextInputAction.next);

    final descriptionField = FormFieldComponents.regularTextField(
        descriptionController,
        "Income Description",
        false,
        Icons.description_rounded,
        TextInputAction.next);

    final amountField = FormFieldComponents.amountTextField(
        amountController, "Cost", TextInputAction.next);

    final categoryField = FormFieldComponents.dropdownCategoryListField(
        categories
            .where("userId", isEqualTo: widget.loggedInUser.uid)
            .where("type", isEqualTo: "Income Category")
            .snapshots(),
        selectedCategory,
        setCategory);

    final dateField =
        FormFieldComponents.dateField(context, dateControll, setDate);

    final addButton = FormFieldComponents.addNewElement(
        context, incomes, addIncome, "Add Income");

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
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 60),
                  nameField,
                  const SizedBox(height: 20),
                  descriptionField,
                  const SizedBox(height: 20),
                  categoryField,
                  const SizedBox(height: 20),
                  amountField,
                  const SizedBox(height: 20),
                  dateField,
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

  void addIncome(CollectionReference incomes) async {
    if (selectedCategory == null ||
        !_formKey.currentState!.validate() ||
        dateControll == null) {
      Fluttertoast.showToast(msg: "Provide all data!");
      return;
    }
    await incomes
        .add({
          'name': nameController.text,
          'description': descriptionController.text,
          'amount': Numeric.formatPrice(amountController.text),
          'userId': widget.loggedInUser.uid,
          'categoryId': selectedCategory,
          'date': dateControll,
          'id': incomes.doc().id,
        })
        .then((value) => Fluttertoast.showToast(msg: "Income added!"))
        .catchError(
            (error) => Fluttertoast.showToast(msg: "Something went wrong..."));
    Navigator.of(context).pop();
  }

  void setCategory(String value) {
    setState(() {
      selectedCategory = value;
    });
  }

  void setDate(DateTime value) {
    setState(() {
      dateControll = value;
    });
  }
}
