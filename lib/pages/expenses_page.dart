import 'package:bilans/models/category_model.dart';
import 'package:bilans/models/expense_model.dart';
import 'package:bilans/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_expense_page.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  Map<String, String> categories = {};

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      FirebaseFirestore.instance
          .collection('categories')
          .where("userId", isEqualTo: loggedInUser.uid)
          .where("type", isEqualTo: "Expense Category")
          .get()
          .then((query) => {
                for (var item in query.docs)
                  {
                    categories.putIfAbsent(CategoryModel.fromMap(item).id!,
                        () => CategoryModel.fromMap(item).name!)
                  },
                setState(() {})
              });
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference expenses =
        FirebaseFirestore.instance.collection('expenses');

    final addExpenseButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddExpensePage()));
        },
        child: const Text(
          "Add Expense",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final list = StreamBuilder<QuerySnapshot>(
        stream:
            expenses.where("userId", isEqualTo: loggedInUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || categories.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data!.docs.isNotEmpty) {
              return Scrollbar(
                child: ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(ExpenseModel.fromMap(doc.data()!).name!),
                            MaterialButton(
                              onPressed: () {
                                doc.reference.delete();
                              },
                              child: const Icon(
                                Icons.remove,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(ExpenseModel.fromMap(doc.data()!)
                                .amount!
                                .toString()),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(categories[ExpenseModel.fromMap(doc.data()!)
                                .categoryId!]!),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  "No Expenses yet",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
          }
        });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                "Your Expenses:",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(height: 400, child: list),
              const SizedBox(
                height: 40,
              ),
              addExpenseButton
            ],
          ),
        ));
  }
}
