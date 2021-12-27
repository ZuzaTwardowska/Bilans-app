import 'package:bilans/models/expense_model.dart';
import 'package:bilans/models/income_model.dart';
import 'package:bilans/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class chartData {
  final String name;
  final int amount;
  final charts.Color color;

  chartData(this.name, this.amount, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class _ReportsPageState extends State<ReportsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  double expenseAmount = 0;
  double incomeAmount = 0;

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
    var data = [
      chartData('expense', expenseAmount.round(), Colors.red),
      chartData('income', incomeAmount.round(), Colors.green),
    ];

    var series = [
      charts.Series(
        domainFn: (chartData chartDataRecord, _) => chartDataRecord.name,
        measureFn: (chartData chartDataRecord, _) => chartDataRecord.amount,
        colorFn: (chartData chartDataRecord, _) => chartDataRecord.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chartWidget = Padding(
      padding: const EdgeInsets.all(32.0),
      child: SizedBox(
        height: 200.0,
        child: charts.PieChart(
          series,
          animate: true,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                const Text("Income:"),
                const SizedBox(
                  width: 20,
                ),
                Text(incomeAmount.toString()),
              ],
            ),
            Row(
              children: [
                const Text("Expense:"),
                const SizedBox(
                  width: 20,
                ),
                Text(expenseAmount.toString()),
              ],
            ),
            chartWidget,
          ],
        ),
      ),
    );
  }
}
