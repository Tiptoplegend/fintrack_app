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
    return today; // Fallback (should never reach here)
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

  startOfweekDate() {}
}
