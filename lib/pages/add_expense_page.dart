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
  final nameEditingController = TextEditingController();
  final descriptionEditingController = TextEditingController();
  final amountEditingController = TextEditingController();
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

    final nameField = TextFormField(
      autofocus: false,
      controller: nameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Expense Name cannot be Empty");
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
        hintText: "Expense Name",
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
        hintText: "Expense Description",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final amountField = TextFormField(
      autofocus: false,
      controller: amountEditingController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
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
      },
      onSaved: (value) {
        amountEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.attach_money),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Amount\\Cost",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final categoryField = StreamBuilder<QuerySnapshot>(
        stream: categories
            .where("userId", isEqualTo: loggedInUser.uid)
            .where("type", isEqualTo: "Expense Category")
            .snapshots(),
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
                        setState(
                          () {
                            selectedCategory = newValue!;
                          },
                        );
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

    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          addExpense(expenses);
        },
        child: const Text(
          "Add Expense",
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
    if (selectedCategory == null ||
        nameEditingController.text.isEmpty ||
        amountEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Provide all data!");
      return;
    }
    await expenses
        .add({
          'name': nameEditingController.text,
          'description': descriptionEditingController.text,
          'amount': amountEditingController.text,
          'userId': loggedInUser.uid,
          'categoryId': selectedCategory,
          'id': expenses.doc().id,
        })
        .then((value) => Fluttertoast.showToast(msg: "Expense added!"))
        .catchError(
            (error) => Fluttertoast.showToast(msg: "Something went wrong..."));
    Navigator.of(context).pop();
  }
}
