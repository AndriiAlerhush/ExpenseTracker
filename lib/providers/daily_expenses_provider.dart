import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/providers/selected_date_provider.dart';
import 'package:expense_tracker/models/expense.dart';

final dailyExpensesProvider = Provider<List<Expense>>((ref) {
  final allExpenses = ref.watch(expensesProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  final normalizedSelectedDate = DateUtils.dateOnly(selectedDate);

  return allExpenses.where((expense) {
    return DateUtils.dateOnly(expense.date) == normalizedSelectedDate;
  }).toList();
});
