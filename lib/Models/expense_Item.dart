import 'package:cloud_firestore/cloud_firestore.dart';
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
      'amount': expenseAmount,
      'date': expenseDate.millisecondsSinceEpoch,
      'expenseNote': expenseNote,
    };
  }

  static DateTime parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime.now(); // fallback
  }

  factory ExpenseItem.fromMap(Map<String, dynamic> map, String documentId) {
    return ExpenseItem(
      id: documentId,
      category: Category(name: map['category'] ?? 'Unknown'),
      expenseAmount: double.tryParse(map['amount'].toString()) ??
          0.0, // Safely parse to double
      expenseDate: parseDate(map['date']),
      expenseNote: map['expenseNote'] ?? "",
    );
  }
}
