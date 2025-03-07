import 'package:fintrack_app/FAB%20pages/Categories.dart';

class ExpenseItem {
  final String id;
  final Category category;
  final double expenseAmount;
  DateTime expenseDate;
  String expenseNote = '';

  ExpenseItem({
    required this.id,
    required this.category,
    required this.expenseAmount,
    required this.expenseDate,
    required this.expenseNote,
  });

  get selectedCategory => null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'expenseAmount': expenseAmount,
      'expenseDate': expenseDate.millisecondsSinceEpoch,
      'expenseNote': expenseNote,
    };
  }

  factory ExpenseItem.fromMap(Map<String, dynamic> map, String documentId) {
    return ExpenseItem(
      id: documentId,
      category: map['category'],
      expenseAmount: map['expenseAmount'],
      expenseDate: DateTime.parse(map['expenseDate']),
      expenseNote: map['notes'] ?? "",
    );
  }
}
