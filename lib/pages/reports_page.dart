import 'package:bilans/components/chart_components.dart';
import 'package:bilans/components/page_components.dart';
import 'package:bilans/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'line_chart_page.dart';

class ReportsPage extends StatefulWidget {
  final UserModel loggedInUser;
  const ReportsPage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
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
    rebuildChart();
  }

  @override
  Widget build(BuildContext context) {
    final periodDropdown = PageComponents.dropdownOptions(
        periodValue,
        (String value) => {
              setState(() {
                periodValue = value;
                rebuildChart();
              })
            },
        ['Month', 'Two Months', 'All']);

    final typeDropdown = PageComponents.dropdownOptions(
        typeValue,
        (String value) => {
              setState(() {
                typeValue = value;
                rebuildChart();
              })
            },
        ['Incomes vs Expenses', 'Income Categories', 'Expense Categories']);

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
            SizedBox(width: 200, child: periodDropdown),
            SizedBox(width: 200, child: typeDropdown),
            const SizedBox(
              height: 40,
            ),
            PageComponents.redirectButton(
                context,
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LineChartPage(
                              loggedInUser: widget.loggedInUser,
                            ))),
                "Line Charts"),
          ],
        ),
      ),
    );
  }

  void rebuildChart() async {
    Map<String, double> series = {};
    setDataChart(series);
    switch (typeValue) {
      case "Incomes vs Expenses":
        series = await ChartComponents.recalculateDataIncomeExpanse(
            periodValue, widget.loggedInUser);
        break;
      case "Income Categories":
        series = await ChartComponents.recalculateDataIncomeCategories(
            periodValue, widget.loggedInUser);
        break;
      case "Expense Categories":
        series = await ChartComponents.recalculateDataExpenseCategories(
            periodValue, widget.loggedInUser);
        break;
    }
    setDataChart(series);
  }

  void setDataChart(Map<String, double> series) {
    setState(() {
      chartWidget = series.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(32.0),
              child: SizedBox(
                height: 200.0,
                child: PieChart(dataMap: series),
              ),
            )
          : const Padding(
              padding: EdgeInsets.fromLTRB(0, 110, 0, 120),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
    });
  }
}
