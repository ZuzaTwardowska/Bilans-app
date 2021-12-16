import 'package:bilans/models/category_model.dart';
import 'package:bilans/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'add_category_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

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

    final addCategoryButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddCategoryPage()));
        },
        child: const Text(
          "Add Category",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final incomeList = StreamBuilder<QuerySnapshot>(
        stream: categories
            .where("userId", isEqualTo: loggedInUser.uid)
            .where("type", isEqualTo: "Income Category")
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
                        title: Text(CategoryModel.fromMap(doc.data()!).name!),
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  "No categories yet :(",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
          }
        });

    final expenseList = StreamBuilder<QuerySnapshot>(
        stream: categories
            .where("userId", isEqualTo: loggedInUser.uid)
            .where("type", isEqualTo: "Expense Category")
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
                        title: Text(CategoryModel.fromMap(doc.data()!).name!),
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
                "Income Categories:",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(height: 220, child: incomeList),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Expense Categories:",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(height: 220, child: expenseList),
              const SizedBox(
                height: 40,
              ),
              addCategoryButton
            ],
          ),
        ));
  }
}
