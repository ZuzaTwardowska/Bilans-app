import 'package:bilans/models/category_model.dart';
import 'package:bilans/models/expense_model.dart';
import 'package:bilans/models/income_model.dart';
import 'package:bilans/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChartComponents {
  static Future<Map<String, double>> recalculateDataIncomeExpanse(
      String period, UserModel loggedInUser) async {
    double expenseAmount = 0;
    double incomeAmount = 0;
    DateTime dateBorder = getDateBorder(period);

    await FirebaseFirestore.instance
        .collection('expenses')
        .where("userId", isEqualTo: loggedInUser.uid)
        .where("date", isGreaterThanOrEqualTo: dateBorder)
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
        .where("date", isGreaterThanOrEqualTo: dateBorder)
        .get()
        .then((query) => {
              for (var item in query.docs)
                {
                  incomeAmount +=
                      double.parse(IncomeModel.fromMap(item).amount!)
                },
            });
    return {"Incomes": incomeAmount, "Expenses": expenseAmount};
  }

  static DateTime getDateBorder(String period) {
    var date = DateTime.now();
    switch (period) {
      case 'Month':
        {
          return DateTime(date.year, date.month, 1);
        }
      case 'Two Months':
        {
          if (date.month > 1) {
            return DateTime(date.year, date.month - 1, 1);
          } else {
            return DateTime(date.year - 1, 12, 1);
          }
        }
      default:
        {
          return DateTime(2000, 1, 1);
        }
    }
  }

  static DateTime addWeekToDate(DateTime date) {
    return date.add(const Duration(days: 7));
  }

  static Future<Map<String, double>> recalculateDataIncomeCategories(
      String period, UserModel loggedInUser) async {
    DateTime dateBorder = getDateBorder(period);
    Map<String, double> series = {};
    Map<String, String> categories =
        await readCategories("Income Category", loggedInUser);
    QuerySnapshot<Map<String, dynamic>> query =
        await readRecords("incomes", loggedInUser, dateBorder);
    for (var item in query.docs) {
      String category = categories[IncomeModel.fromMap(item).categoryId!]!;
      series.putIfAbsent(category, () => 0);
      double value = series[category]!;
      series[category] =
          value + double.parse(IncomeModel.fromMap(item).amount!);
    }
    return series;
  }

  static Future<Map<String, double>> recalculateDataExpenseCategories(
      String period, UserModel loggedInUser) async {
    DateTime dateBorder = getDateBorder(period);
    Map<String, double> series = {};
    Map<String, String> categories =
        await readCategories("Expense Category", loggedInUser);
    QuerySnapshot<Map<String, dynamic>> query =
        await readRecords("expenses", loggedInUser, dateBorder);
    for (var item in query.docs) {
      String category = categories[ExpenseModel.fromMap(item).categoryId!]!;
      series.putIfAbsent(category, () => 0);
      double value = series[category]!;
      series[category] =
          value + double.parse(ExpenseModel.fromMap(item).amount!);
    }
    return series;
  }

  static Future<Map<String, String>> readCategories(
      String type, UserModel loggedInUser) async {
    Map<String, String> categories = {};
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection('categories')
        .where("userId", isEqualTo: loggedInUser.uid)
        .where("type", isEqualTo: type)
        .get();
    for (var item in query.docs) {
      categories.putIfAbsent(CategoryModel.fromMap(item).id!,
          () => CategoryModel.fromMap(item).name!);
    }
    return categories;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> readRecords(
      String type, UserModel loggedInUser, DateTime dateBorder) async {
    return await FirebaseFirestore.instance
        .collection(type)
        .where("userId", isEqualTo: loggedInUser.uid)
        .where("date", isGreaterThanOrEqualTo: dateBorder)
        .get();
  }

  static Future<Map<DateTime, double>> getIncomeDataForLineChart(
      DateTime date, UserModel loggedInUser) async {
    QuerySnapshot<Map<String, dynamic>> records = await FirebaseFirestore
        .instance
        .collection("incomes")
        .where("userId", isEqualTo: loggedInUser.uid)
        .where("date", isGreaterThanOrEqualTo: date)
        .where("date", isLessThanOrEqualTo: addWeekToDate(date))
        .get();
    Map<DateTime, double> res = {};
    for (var item in records.docs) {
      DateTime itemDate = DateTime(
          IncomeModel.fromMap(item).date!.year,
          IncomeModel.fromMap(item).date!.month,
          IncomeModel.fromMap(item).date!.day);
      res.putIfAbsent(itemDate, () => 0);
      double value = res[itemDate]!;
      res[itemDate] = value + double.parse(IncomeModel.fromMap(item).amount!);
    }
    return res;
  }

  static Future<Map<DateTime, double>> getExpenseDataForLineChart(
      DateTime date, UserModel loggedInUser) async {
    QuerySnapshot<Map<String, dynamic>> records = await FirebaseFirestore
        .instance
        .collection("expenses")
        .where("userId", isEqualTo: loggedInUser.uid)
        .where("date", isGreaterThanOrEqualTo: date)
        .where("date", isLessThanOrEqualTo: addWeekToDate(date))
        .get();
    Map<DateTime, double> res = {};
    for (var item in records.docs) {
      DateTime itemDate = DateTime(
          ExpenseModel.fromMap(item).date!.year,
          ExpenseModel.fromMap(item).date!.month,
          ExpenseModel.fromMap(item).date!.day);
      res.putIfAbsent(itemDate, () => 0);
      double value = res[itemDate]!;
      res[itemDate] = value + double.parse(ExpenseModel.fromMap(item).amount!);
    }
    return res;
  }
}
