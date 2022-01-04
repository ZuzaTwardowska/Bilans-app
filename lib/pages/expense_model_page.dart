import 'package:bilans/components/firebase_storage_components.dart';
import 'package:bilans/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:linkwell/linkwell.dart';
import 'photo_page.dart';

class ExpenseModelPage extends StatefulWidget {
  final ExpenseModel expense;
  final String category;
  const ExpenseModelPage(
      {Key? key, required this.expense, required this.category})
      : super(key: key);

  @override
  _ExpenseModelPageState createState() => _ExpenseModelPageState();
}

class _ExpenseModelPageState extends State<ExpenseModelPage> {
  Image? photo;
  Widget photoItem = const SizedBox(width: 0, height: 0);
  @override
  void initState() {
    super.initState();
    loadPhoto();
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text(
                    "Expense Panel",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: const [
                            Text(
                              "Name:",
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Category:",
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Date:",
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Amount:",
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Description:",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Column(
                            children: [
                              Text(
                                widget.expense.name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.category,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                DateFormat("dd-MM-yyyy")
                                    .format(widget.expense.date!),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.expense.amount!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              LinkWell(
                                widget.expense.description!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  photoItem,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadPhoto() async {
    var loadedPhoto = await FirebaseStorageComponents.getImage(
        context, "expensePhotos/" + widget.expense.id!);
    if (loadedPhoto == null) return;
    setState(() {
      photo = loadedPhoto;
      photoItem = SizedBox(
        width: 200,
        child: GestureDetector(
          child: photo,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return PhotoPage(image: photo!);
            }));
          },
        ),
      );
    });
  }
}
