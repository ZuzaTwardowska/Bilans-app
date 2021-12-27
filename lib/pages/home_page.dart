import 'package:bilans/components/page_components.dart';
import 'package:bilans/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'categories_page.dart';
import 'expenses_page.dart';
import 'incomes_page.dart';
import 'login_page.dart';
import 'reports_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    final expenseButton = PageComponents.redirectButton(
        context,
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ExpensesPage())),
        "Expenses");

    final incomeButton = PageComponents.redirectButton(
        context,
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const IncomesPage())),
        "Incomes");

    final categoryButton = PageComponents.redirectButton(
        context,
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CategoriesPage())),
        "Categories");

    final tableButton = PageComponents.redirectButton(
        context,
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ReportsPage())),
        "Reports and Charts");

    final logoutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          logout(context);
        },
        child: const Text(
          "Logout",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final userInfo = Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          Column(
            children: const [
              Text(
                "Logged as:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Expanded(
            child: Column(children: [
              Text(
                "${loggedInUser.name} ${loggedInUser.surname}",
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                "${loggedInUser.email}",
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ]),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bilans"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Expanded(
          child: Column(
            children: <Widget>[
              userInfo,
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    expenseButton,
                    const SizedBox(
                      height: 22,
                    ),
                    incomeButton,
                    const SizedBox(
                      height: 22,
                    ),
                    categoryButton,
                    const SizedBox(
                      height: 22,
                    ),
                    tableButton,
                    const SizedBox(
                      height: 22,
                    ),
                    logoutButton
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
