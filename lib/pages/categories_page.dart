import 'package:bilans/components/page_components.dart';
import 'package:bilans/models/user_model.dart';
import 'package:flutter/material.dart';
import 'add_category_page.dart';

class CategoriesPage extends StatefulWidget {
  final UserModel loggedInUser;
  const CategoriesPage({Key? key, required this.loggedInUser})
      : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addCategoryButton = PageComponents.redirectButton(
        context,
        () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddCategoryPage(
                      loggedInUser: widget.loggedInUser,
                    ))),
        "Add Category");

    final incomeList = PageComponents.categoriesRecordList(
        widget.loggedInUser, "Income Category");

    final expenseList = PageComponents.categoriesRecordList(
        widget.loggedInUser, "Expense Category");

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
            SizedBox(height: 200, child: incomeList),
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
            SizedBox(height: 200, child: expenseList),
            const SizedBox(
              height: 40,
            ),
            addCategoryButton
          ],
        ),
      ),
    );
  }
}
