import 'package:bilans/models/expense_model.dart';
import 'package:bilans/models/income_model.dart';
import 'package:bilans/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChartComponents {
  static Future<List<double>> recalculateDataIncomeExpanse(
      String period, UserModel loggedInUser) async {
    var date = DateTime.now();
    double expenseAmount = 0;
    double incomeAmount = 0;
    switch (period) {
      case 'Month':
        {
          await FirebaseFirestore.instance
              .collection('expenses')
              .where("userId", isEqualTo: loggedInUser.uid)
              .where("date",
                  isLessThanOrEqualTo: DateTime(date.year, date.month, 1))
              .get()
              .then((query) => {
                    for (var item in query.docs)
                      {
                        expenseAmount +=
                            double.parse(ExpenseModel.fromMap(item).amount!)
                      },
                  });
          await FirebaseFirestore.instance
              .collection('incomes')
              .where("userId", isEqualTo: loggedInUser.uid)
              .where("date",
                  isLessThanOrEqualTo: DateTime(date.year, date.month, 1))
              .get()
              .then((query) => {
                    for (var item in query.docs)
                      {
                        incomeAmount +=
                            double.parse(IncomeModel.fromMap(item).amount!)
                      },
                  });
          break;
        }
      case 'Two Months':
        {
          DateTime dateBorder;
          if (date.month > 1) {
            dateBorder = DateTime(date.year, date.month - 1, 1);
          } else {
            dateBorder = DateTime(date.year - 1, 12, 1);
          }
          await FirebaseFirestore.instance
              .collection('expenses')
              .where("userId", isEqualTo: loggedInUser.uid)
              .where("date", isLessThanOrEqualTo: dateBorder)
              .get()
              .then((query) => {
                    for (var item in query.docs)
                      {
                        expenseAmount +=
                            double.parse(ExpenseModel.fromMap(item).amount!)
                      },
                  });
          await FirebaseFirestore.instance
              .collection('incomes')
              .where("userId", isEqualTo: loggedInUser.uid)
              .where("date", isLessThanOrEqualTo: dateBorder)
              .get()
              .then((query) => {
                    for (var item in query.docs)
                      {
                        incomeAmount +=
                            double.parse(IncomeModel.fromMap(item).amount!)
                      },
                  });
          break;
        }
      case 'All':
        {
          await FirebaseFirestore.instance
              .collection('expenses')
              .where("userId", isEqualTo: loggedInUser.uid)
              .get()
              .then((query) => {
                    for (var item in query.docs)
                      {
                        expenseAmount +=
                            double.parse(ExpenseModel.fromMap(item).amount!)
                      },
                  });
          await FirebaseFirestore.instance
              .collection('incomes')
              .where("userId", isEqualTo: loggedInUser.uid)
              .get()
              .then((query) => {
                    for (var item in query.docs)
                      {
                        incomeAmount +=
                            double.parse(IncomeModel.fromMap(item).amount!)
                      },
                  });
          break;
        }
      default:
    }
    return [incomeAmount, expenseAmount];
  }
}
