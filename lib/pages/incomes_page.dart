import 'package:bilans/components/chart_components.dart';
import 'package:bilans/components/page_components.dart';
import 'package:bilans/models/user_model.dart';
import 'package:flutter/material.dart';
import 'add_income_page.dart';

class IncomesPage extends StatefulWidget {
  final UserModel loggedInUser;
  const IncomesPage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _IncomesPageState createState() => _IncomesPageState();
}

class _IncomesPageState extends State<IncomesPage> {
  SizedBox list = const SizedBox(
    height: 400,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  void initState() {
    super.initState();
    setList();
  }

  @override
  Widget build(BuildContext context) {
    final addIncomeButton = PageComponents.redirectButton(
        context,
        () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddIncomePage(
                      loggedInUser: widget.loggedInUser,
                    ))),
        "Add Income");

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
              list,
              const SizedBox(
                height: 40,
              ),
              addIncomeButton
            ],
          ),
        ));
  }

  void setList() async {
    Map<String, String> categories = await ChartComponents.readCategories(
        "Income Category", widget.loggedInUser);
    setState(() {
      list = PageComponents.incomeRecordList(widget.loggedInUser, categories);
    });
  }
}
