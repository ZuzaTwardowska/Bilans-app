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
  String dropdownValue = 'All';
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
      rebuildChart("All");
    });
  }

  @override
  Widget build(BuildContext context) {
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
          rebuildChart(newValue);
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

  void rebuildChart(String period) async {
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
}
