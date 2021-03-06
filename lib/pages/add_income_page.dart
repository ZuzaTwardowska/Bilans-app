import 'package:bilans/components/chart_components.dart';
import 'package:bilans/components/database_components.dart';
import 'package:bilans/components/form_field_components.dart';
import 'package:bilans/models/user_model.dart';
import 'package:flutter/material.dart';

class AddIncomePage extends StatefulWidget {
  final UserModel loggedInUser;
  const AddIncomePage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  String? selectedCategory;
  DateTime? dateControll;
  Center categoryField = const Center(
    child: CircularProgressIndicator(),
  );

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final nameField = FormFieldComponents.regularTextField(nameController,
        "Income title", true, Icons.category_rounded, TextInputAction.next);

    final descriptionField = FormFieldComponents.regularTextField(
        descriptionController,
        "Income Description",
        false,
        Icons.description_rounded,
        TextInputAction.next);

    final amountField = FormFieldComponents.amountTextField(
        amountController, "Cost", TextInputAction.next);

    final dateField = FormFieldComponents.dateField(
        context,
        dateControll,
        (DateTime value) => {
              setState(() {
                dateControll = value;
              })
            });

    final addButton = FormFieldComponents.addNewElement(
        context,
        DatabaseComponents.addIncome,
        "Add Income",
        _formKey,
        widget.loggedInUser,
        [nameController, descriptionController, amountController],
        selectedCategory,
        dateControll,
        null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Builder(builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    nameField,
                    const SizedBox(height: 20),
                    descriptionField,
                    const SizedBox(height: 20),
                    categoryField,
                    const SizedBox(height: 20),
                    amountField,
                    const SizedBox(height: 20),
                    dateField,
                    const SizedBox(height: 20),
                    addButton,
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void loadCategories() async {
    Map<String, String> categories = await ChartComponents.readCategories(
        "Income Category", widget.loggedInUser);
    setState(() {
      categoryField = Center(
        child: FormFieldComponents.dropdownCategoryListField(
          categories,
          selectedCategory,
          (String value) => {
            setState(() {
              selectedCategory = value;
              loadCategories();
            })
          },
        ),
      );
    });
  }
}
