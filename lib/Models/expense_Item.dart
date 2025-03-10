import 'package:fintrack_app/FAB%20pages/Categories.dart';

class ExpenseItem {
  late final String id;
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
      'category': category.name,
      'expenseAmount': expenseAmount,
      'expenseDate': expenseDate.millisecondsSinceEpoch,
      'expenseNote': expenseNote,
    };
  }

  factory ExpenseItem.fromMap(Map<String, dynamic> map, String documentId) {
    return ExpenseItem(
      id: documentId,
      category: Category(name: map['category']),
      expenseAmount: map['expenseAmount'].toDouble(),
      expenseDate: DateTime.fromMillisecondsSinceEpoch(map['expenseDate']),
      expenseNote: map['expenseNote'] ?? "",
    );
  }
}
