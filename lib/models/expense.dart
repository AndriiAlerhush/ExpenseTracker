import 'package:expense_tracker/models/enum_categories.dart';

class Expense {
  // ignore: non_constant_identifier_names
  static int _ID = 0;

  Expense({
    required this.category,
    required this.amount,
    required this.date,
    required this.createdAt,
    this.comment,
  }) : id = ++_ID;

  final int id;
  final Category category;
  final double amount;
  final String? comment;
  final DateTime date;
  final DateTime createdAt;
}
