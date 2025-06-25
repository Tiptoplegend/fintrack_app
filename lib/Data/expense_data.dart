import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack_app/Models/expense_Item.dart';
import 'package:fintrack_app/Datetime/date_time_helper.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  // list expense
  List<ExpenseItem> overallExpenseList = [];
// get expense
  List<ExpenseItem> getExpenseList() {
    return overallExpenseList;
  }

// add expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners();
  }

  void loadExpensesFromFirestore(QuerySnapshot snapshot) {
    overallExpenseList.clear(); // Clear previous entries
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final item = ExpenseItem.fromMap(data, doc.id);
      overallExpenseList.add(item);
    }
    notifyListeners();
  }

// del the expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
  }

  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  DateTime StartOfWeekDate() {
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime candidate = today.subtract(Duration(days: i));
      if (getDayName(candidate) == 'Sun') {
        return candidate;
      }
    }
    return today;
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.expenseDate);
      // print('Expense summary key: $date');
      double amount = expense.expenseAmount;

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary[date] = amount;
      }
    }

    return dailyExpenseSummary;
  }

  String calculateWeekTotal(DateTime weekStart) {
    double total = 0;
    Map<String, double> dailyExpenseSummary = calculateDailyExpenseSummary();

    String sunday = convertDateTimeToString(weekStart);
    String monday =
        convertDateTimeToString(weekStart.add(const Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(weekStart.add(const Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(weekStart.add(const Duration(days: 3)));
    String thursday =
        convertDateTimeToString(weekStart.add(const Duration(days: 4)));
    String friday =
        convertDateTimeToString(weekStart.add(const Duration(days: 5)));
    String saturday =
        convertDateTimeToString(weekStart.add(const Duration(days: 6)));

    total += (dailyExpenseSummary[sunday] ?? 0);
    total += (dailyExpenseSummary[monday] ?? 0);
    total += (dailyExpenseSummary[tuesday] ?? 0);
    total += (dailyExpenseSummary[wednesday] ?? 0);
    total += (dailyExpenseSummary[thursday] ?? 0);
    total += (dailyExpenseSummary[friday] ?? 0);
    total += (dailyExpenseSummary[saturday] ?? 0);

    return total.toStringAsFixed(2);
  }

  // calculate yearly total
  double calculateYearTotal(int year) {
    double total = 0;
    DateTime startOfYear = DateTime(year, 1, 1);
    DateTime endOfYear = DateTime(year, 12, 31);

    for (var expense in overallExpenseList) {
      if (expense.expenseDate
              .isAfter(startOfYear.subtract(const Duration(days: 1))) &&
          expense.expenseDate
              .isBefore(endOfYear.add(const Duration(days: 1)))) {
        total += expense.expenseAmount;
      }
    }
    return total;
  }

  startOfweekDate() {}
}
