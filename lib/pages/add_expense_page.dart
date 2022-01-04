import 'dart:io';
import 'package:bilans/components/chart_components.dart';
import 'package:bilans/components/database_components.dart';
import 'package:bilans/components/form_field_components.dart';
import 'package:bilans/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddExpensePage extends StatefulWidget {
  final UserModel loggedInUser;
  const AddExpensePage({Key? key, required this.loggedInUser})
      : super(key: key);

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? dateControll;
  String? selectedCategory;
  File? imageFile;
  Icon photoIcon = const Icon(Icons.add_a_photo_rounded, color: Colors.white);
  final ImagePicker imagePicker = ImagePicker();
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
        "Expense title", true, Icons.category_rounded, TextInputAction.next);

    final descriptionField = FormFieldComponents.regularTextField(
        descriptionController,
        "Expense Description",
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
        DatabaseComponents.addExpense,
        "Add Expense",
        _formKey,
        widget.loggedInUser,
        [nameController, descriptionController, amountController],
        selectedCategory,
        dateControll,
        imageFile);

    final addPhotoField = Padding(
      padding: const EdgeInsets.all(0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        color: Colors.black38,
        child: MaterialButton(
          onPressed: () {
            showModalBottomSheet(context: context, builder: bottomPhotoPanel);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              photoIcon,
              const SizedBox(
                width: 20,
              ),
              const Text(
                "Add Photo",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
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
                  addPhotoField,
                  const SizedBox(height: 20),
                  addButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loadCategories() async {
    Map<String, String> categories = await ChartComponents.readCategories(
        "Expense Category", widget.loggedInUser);
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

  Widget bottomPhotoPanel(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            "Add Photo",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                  onPressed: () {
                    choosePhoto(ImageSource.camera);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.camera_alt_rounded),
                      SizedBox(width: 10),
                      Text(
                        "Camera",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )),
              MaterialButton(
                onPressed: () {
                  choosePhoto(ImageSource.gallery);
                },
                child: Row(
                  children: const [
                    Icon(Icons.image),
                    SizedBox(width: 10),
                    Text(
                      "Gallery",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void choosePhoto(ImageSource source) async {
    final pickedFile = await imagePicker.getImage(source: source);
    Navigator.pop(context);
    if (pickedFile == null) return;
    setState(() {
      imageFile = File(pickedFile.path);
      photoIcon = const Icon(Icons.done, color: Colors.white);
    });
  }
}
