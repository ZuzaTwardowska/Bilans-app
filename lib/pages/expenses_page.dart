import 'package:bilans/components/chart_components.dart';
import 'package:bilans/components/page_components.dart';
import 'package:bilans/models/expense_model.dart';
import 'package:bilans/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_expense_page.dart';
import 'package:intl/intl.dart';

import 'expense_model_page.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  Map<String, String> categories = {};
  SizedBox list = const SizedBox(
    height: 400,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final addExpenseButton = PageComponents.redirectButton(
        context,
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddExpensePage())),
        "Add Expense");

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
            list,
            const SizedBox(
              height: 40,
            ),
            addExpenseButton
          ],
        ),
      ),
    );
  }

  void setList() async {
    categories =
        await ChartComponents.readCategories("Expense Category", loggedInUser);
    setState(() {
      list = SizedBox(
          height: 400,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('expenses')
                  .where("userId", isEqualTo: loggedInUser.uid)
                  .orderBy('date', descending: true)
                  .snapshots(),
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
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExpenseModelPage(
                                    expense: ExpenseModel.fromMap(doc.data()!),
                                    category: categories[
                                        ExpenseModel.fromMap(doc.data()!)
                                            .categoryId!]!,
                                  ),
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  Text(categories[
                                      ExpenseModel.fromMap(doc.data()!)
                                          .categoryId!]!),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(DateFormat("dd-MM-yyyy").format(
                                      ExpenseModel.fromMap(doc.data()!).date!)),
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
              }));
    });
  }
}
