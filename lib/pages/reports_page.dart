import 'package:bilans/components/chart_components.dart';
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
  String periodValue = 'All';
  String typeValue = 'Incomes vs Expenses';
  var chartWidget = const Padding(
    padding: EdgeInsets.fromLTRB(0, 110, 0, 120),
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
      rebuildChart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final periodDropdown = DropdownButton<String>(
      value: periodValue,
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
          periodValue = newValue!;
          rebuildChart();
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

    final typeDropdown = DropdownButton<String>(
      value: typeValue,
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
          typeValue = newValue!;
          rebuildChart();
        });
      },
      items: <String>[
        'Incomes vs Expenses',
        'Income Categories',
        'Expense Categories'
      ].map<DropdownMenuItem<String>>((String value) {
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
            periodDropdown,
            typeDropdown
          ],
        ),
      ),
    );
  }

  void rebuildChartIncomeExpenses(String period) async {
    setState(() {
      chartWidget = const Padding(
        padding: EdgeInsets.fromLTRB(0, 110, 0, 120),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
    var seriesList = await ChartComponents.recalculateDataIncomeExpanse(
        period, loggedInUser);
    Map<String, double> series = {
      "Incomes": seriesList[0],
      "Expenses": seriesList[1],
    };
    setState(() {
      chartWidget = Padding(
        padding: const EdgeInsets.all(32.0),
        child: SizedBox(
          height: 200.0,
          child: PieChart(dataMap: series),
        ),
      );
    });
  }

  void rebuildChartIncomeCategories(String period) async {
    setState(() {
      chartWidget = const Padding(
        padding: EdgeInsets.fromLTRB(0, 110, 0, 120),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
    var series = await ChartComponents.recalculateDataIncomeCategories(
        period, loggedInUser);
    setState(() {
      chartWidget = Padding(
        padding: const EdgeInsets.all(32.0),
        child: SizedBox(
          height: 200.0,
          child: PieChart(dataMap: series),
        ),
      );
    });
  }

  void rebuildChartExpenseCategories(String period) async {
    setState(() {
      chartWidget = const Padding(
        padding: EdgeInsets.fromLTRB(0, 110, 0, 120),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
    var series = await ChartComponents.recalculateDataExpenseCategories(
        period, loggedInUser);
    setState(() {
      chartWidget = Padding(
        padding: const EdgeInsets.all(32.0),
        child: SizedBox(
          height: 200.0,
          child: PieChart(dataMap: series),
        ),
      );
    });
  }

  void rebuildChart() {
    switch (typeValue) {
      case "Incomes vs Expenses":
        rebuildChartIncomeExpenses(periodValue);
        break;
      case "Income Categories":
        rebuildChartIncomeCategories(periodValue);
        break;
      case "Expense Categories":
        rebuildChartExpenseCategories(periodValue);
        break;
    }
  }
}
