import 'package:bilans/components/chart_components.dart';
import 'package:bilans/components/chart_painter.dart';
import 'package:bilans/components/form_field_components.dart';
import 'package:bilans/components/page_components.dart';
import 'package:bilans/models/user_model.dart';
import 'package:flutter/material.dart';

class LineChartPage extends StatefulWidget {
  final UserModel loggedInUser;
  const LineChartPage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _LineChartPageState createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  String typeValue = 'Expenses';
  DateTime dateControll =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(const Duration(days: 7));
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
    final typeDropdown = PageComponents.dropdownOptions(
        typeValue,
        (String value) => {
              setState(() {
                typeValue = value;
                rebuildChart();
              })
            },
        ['Incomes', 'Expenses']);

    final dateField = FormFieldComponents.dateField(
        context,
        dateControll,
        (DateTime value) => {
              setState(() {
                dateControll = value;
                rebuildChart();
              })
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
          children: <Widget>[
            const SizedBox(height: 40),
            chartWidget,
            const SizedBox(height: 40),
            SizedBox(width: 200, child: typeDropdown),
            dateField,
          ],
        ),
      ),
    );
  }

  void rebuildChart() async {
    Map<DateTime, double> series = {};
    switch (typeValue) {
      case "Incomes":
        series = await ChartComponents.getIncomeDataForLineChart(
            dateControll, widget.loggedInUser);
        break;
      case "Expenses":
        series = await ChartComponents.getExpenseDataForLineChart(
            dateControll, widget.loggedInUser);
        break;
    }
    setDataChart(series);
  }

  void setDataChart(Map<DateTime, double> series) {
    List<double> weekData = [];
    DateTime date = dateControll;
    for (int i = 0; i < 7; i++) {
      if (series.containsKey(date)) {
        weekData.add(series[date]!);
      } else {
        weekData.add(0);
      }
      date = date.add(const Duration(days: 1));
    }
    setState(() {
      chartWidget = Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          height: 200.0,
          child: CustomPaint(
            painter: ChartPainter(weekData, dateControll),
            child: Container(),
          ),
        ),
      );
    });
  }
}
