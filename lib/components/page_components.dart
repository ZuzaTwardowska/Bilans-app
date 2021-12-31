import 'package:bilans/models/category_model.dart';
import 'package:bilans/models/expense_model.dart';
import 'package:bilans/models/income_model.dart';
import 'package:bilans/models/user_model.dart';
import 'package:bilans/pages/expense_model_page.dart';
import 'package:bilans/pages/income_model.page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PageComponents {
  static Material redirectButton(
      BuildContext context, Function onClickAction, String name) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          onClickAction();
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

  static DropdownButton<String> dropdownOptions(
      String changeValue, Function changeFunction, List<String> values) {
    return DropdownButton<String>(
      value: changeValue,
      icon: const Icon(
        Icons.arrow_downward,
        color: Colors.redAccent,
      ),
      elevation: 16,
      style: const TextStyle(color: Colors.redAccent),
      underline: Container(
        height: 2,
        color: Colors.redAccent,
      ),
      onChanged: (String? newValue) {
        changeFunction(newValue!);
      },
      items: values.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  static SizedBox incomeRecordList(
      UserModel loggedInUser, Map<String, String> categories) {
    return SizedBox(
      height: 400,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('incomes')
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
                            builder: (context) => IncomeModelPage(
                              income: IncomeModel.fromMap(doc.data()!),
                              category: categories[
                                  IncomeModel.fromMap(doc.data()!)
                                      .categoryId!]!,
                            ),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(IncomeModel.fromMap(doc.data()!).name!),
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
                            Text(IncomeModel.fromMap(doc.data()!)
                                .amount!
                                .toString()),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(categories[
                                IncomeModel.fromMap(doc.data()!).categoryId!]!),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(DateFormat("dd-MM-yyyy").format(
                                IncomeModel.fromMap(doc.data()!).date!)),
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
                  "No Incomes yet",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
          }
        },
      ),
    );
  }

  static SizedBox expenseRecordList(
      UserModel loggedInUser, Map<String, String> categories) {
    return SizedBox(
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
        },
      ),
    );
  }

  static StreamBuilder<QuerySnapshot> categoriesRecordList(
      UserModel loggedInUser, String categoryType) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .where("userId", isEqualTo: loggedInUser.uid)
            .where("type", isEqualTo: categoryType)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
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
                            Text(CategoryModel.fromMap(doc.data()!).name!),
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
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              return const Text("No categories yet :(");
            }
          }
        });
  }
}
