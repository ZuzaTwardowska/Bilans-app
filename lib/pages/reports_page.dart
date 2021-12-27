import 'package:bilans/models/expense_model.dart';
import 'package:bilans/models/income_model.dart';
import 'package:bilans/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  double expenseAmount = 0;
  double incomeAmount = 0;
  String dropdownValue = 'All';

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
          .collection('expenses')
          .where("userId", isEqualTo: loggedInUser.uid)
          .get()
          .then((query) => {
                for (var item in query.docs)
                  {
                    setState(() {
                      expenseAmount +=
                          double.parse(ExpenseModel.fromMap(item).amount!);
                    }),
                  },
              });
      FirebaseFirestore.instance
          .collection('incomes')
          .where("userId", isEqualTo: loggedInUser.uid)
          .get()
          .then((query) => {
                for (var item in query.docs)
                  {
                    setState(() {
                      incomeAmount +=
                          double.parse(IncomeModel.fromMap(item).amount!);
                    }),
                  },
              });
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> series = {
      "Incomes": incomeAmount,
      "Expenses": expenseAmount,
    };

    var chartWidget = Padding(
      padding: const EdgeInsets.all(32.0),
      child: SizedBox(
        height: 200.0,
        child: PieChart(dataMap: series),
      ),
    );

    final periodDropdown = DropdownButton<String>(
      value: dropdownValue,
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
        setState(() {
          dropdownValue = newValue!;
          recalculateData(newValue);
        });
      },
      items: <String>['Month', 'Two Months', 'All']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const Center(
              child: Text(
                "Charts and Reports",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            chartWidget,
            periodDropdown
          ],
        ),
      ),
    );
  }

  void recalculateData(String period) {
    var date = DateTime.now();
    switch (period) {
      case 'Month':
        {
          expenseAmount = 0;
          incomeAmount = 0;
          FirebaseFirestore.instance
              .collection('expenses')
              .where("userId", isEqualTo: loggedInUser.uid)
              .where("date",
                  isLessThanOrEqualTo: DateTime(date.year, date.month, 1))
              .get()
              .then((query) => {
                    for (var item in query.docs)
                      {
                        setState(() {
                          expenseAmount +=
                              double.parse(ExpenseModel.fromMap(item).amount!);
                        }),
                      },
                  });
          FirebaseFirestore.instance
              .collection('incomes')
              .where("userId", isEqualTo: loggedInUser.uid)
              .where("date",
                  isLessThanOrEqualTo: DateTime(date.year, date.month, 1))
              .get()
              .then((query) => {
                    for (var item in query.docs)
                      {
                        setState(() {
                          incomeAmount +=
                              double.parse(IncomeModel.fromMap(item).amount!);
                        }),
                      },
                  });
          break;
        }
      case 'Two Months':
        {
          DateTime dateBorder;
          if (date.month > 1) {
            dateBorder = DateTime(date.year, date.month - 1, 1);
          } else {
            dateBorder = DateTime(date.year - 1, 12, 1);
          }
          expenseAmount = 0;
          incomeAmount = 0;
          FirebaseFirestore.instance
              .collection('expenses')
              .where("userId", isEqualTo: loggedInUser.uid)
              .where("date", isLessThanOrEqualTo: dateBorder)
              .get()
              .then((query) => {
                    for (var item in query.docs)
                      {
                        setState(() {
                          expenseAmount +=
                              double.parse(ExpenseModel.fromMap(item).amount!);
                        }),
                      },
                  });
          FirebaseFirestore.instance
              .collection('incomes')
              .where("userId", isEqualTo: loggedInUser.uid)
              .where("date", isLessThanOrEqualTo: dateBorder)
              .get()
              .then((query) => {
                    for (var item in query.docs)
                      {
                        setState(() {
                          incomeAmount +=
                              double.parse(IncomeModel.fromMap(item).amount!);
                        }),
                      },
                  });
          break;
        }
      case 'All':
        {
          expenseAmount = 0;
          incomeAmount = 0;
          FirebaseFirestore.instance
              .collection('expenses')
              .where("userId", isEqualTo: loggedInUser.uid)
              .get()
              .then((query) => {
                    for (var item in query.docs)
                      {
                        setState(() {
                          expenseAmount +=
                              double.parse(ExpenseModel.fromMap(item).amount!);
                        }),
                      },
                  });
          FirebaseFirestore.instance
              .collection('incomes')
              .where("userId", isEqualTo: loggedInUser.uid)
              .get()
              .then((query) => {
                    for (var item in query.docs)
                      {
                        setState(() {
                          incomeAmount +=
                              double.parse(IncomeModel.fromMap(item).amount!);
                        }),
                      },
                  });
          break;
        }
      default:
    }
  }
}
