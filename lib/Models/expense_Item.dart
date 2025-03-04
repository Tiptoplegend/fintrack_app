import 'package:fintrack_app/FAB%20pages/Categories.dart';

class ExpenseItem {
  final Category category;
  final double expenseAmount;
  DateTime expenseDate;
  String expenseNote = '';

  ExpenseItem({
    required this.category,
    required this.expenseAmount,
    required this.expenseDate,
    required this.expenseNote,
  });

  get selectedCategory => null;
}
