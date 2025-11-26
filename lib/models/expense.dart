import 'package:expense_tracker/models/enum_categories.dart';

class Expense {
  const Expense({
    required this.category,
    required this.amount,
    required this.date,
    required this.createdAt,
    this.id = '',
    this.comment,
  });

  final String id;
  final Category category;
  final double amount;
  final String? comment;
  final DateTime date;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'category': category.name,
      'amount': amount,
      'comment': comment,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map, String id) {
    return Expense(
      id: id,
      category: Category.values.firstWhere((c) => c.name == map['category']),
      amount: (map['amount'] as num).toDouble(),
      comment: map['comment'],
      date: DateTime.parse(map['date']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
