import 'package:fintrack_app/FAB%20pages/Categories.dart';

class ExpenseItem {
  final Category category;
  double expenseAmount;
  DateTime expenseDate;

  ExpenseItem({
    required this.category,
    required this.expenseAmount,
    required this.expenseDate,
  });
}
