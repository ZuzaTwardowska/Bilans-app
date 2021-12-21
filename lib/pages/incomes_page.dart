import 'package:bilans/components/page_components.dart';
import 'package:bilans/models/category_model.dart';
import 'package:bilans/models/income_model.dart';
import 'package:bilans/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_income_page.dart';

class IncomesPage extends StatefulWidget {
  const IncomesPage({Key? key}) : super(key: key);

  @override
  _IncomesPageState createState() => _IncomesPageState();
}

class _IncomesPageState extends State<IncomesPage> {
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
          .where("type", isEqualTo: "Income Category")
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
    CollectionReference incomes =
        FirebaseFirestore.instance.collection('incomes');

    final addIncomeButton = PageComponents.redirectButton(
        context,
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddIncomePage())),
        "Add Income");

    final list = StreamBuilder<QuerySnapshot>(
        stream:
            incomes.where("userId", isEqualTo: loggedInUser.uid).snapshots(),
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
                "Your Incomes:",
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
              addIncomeButton
            ],
          ),
        ));
  }
}
