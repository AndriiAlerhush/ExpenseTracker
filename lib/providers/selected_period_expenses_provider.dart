import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/models/enum_period.dart';
import 'package:expense_tracker/providers/selected_period_provider.dart';
import 'package:expense_tracker/providers/expense_list_provider.dart';
import 'package:expense_tracker/providers/selected_date_provider.dart';
import 'package:expense_tracker/models/expense.dart';

final selectedPeriodExpenseProvider = Provider<AsyncValue<List<Expense>>>((
  ref,
) {
  final allExpensesAsync = ref.watch(expenseListProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  final selectedPeriod = ref.watch(selectedPeriodProvider);
  final selectedRangePeriod = ref.watch(selectedRangeProvider);

  final normalizedSelectedDate = DateUtils.dateOnly(selectedDate);

  return allExpensesAsync.whenData((expenses) {
    return expenses.where((expense) {
      final expenseDate = DateUtils.dateOnly(expense.date);

      switch (selectedPeriod) {
        case EnumPeriod.day:
          return expenseDate == normalizedSelectedDate;

        case EnumPeriod.week:
          final startOfWeek = normalizedSelectedDate.subtract(
            Duration(days: normalizedSelectedDate.weekday - 1),
          );
          final endOfWeek = startOfWeek.add(const Duration(days: 6));

          return expenseDate.isAfter(
                startOfWeek.subtract(const Duration(seconds: 1)),
              ) &&
              expenseDate.isBefore(endOfWeek.add(const Duration(seconds: 1)));

        case EnumPeriod.month:
          return expenseDate.year == normalizedSelectedDate.year &&
              expenseDate.month == normalizedSelectedDate.month;

        case EnumPeriod.year:
          return expenseDate.year == normalizedSelectedDate.year;

        case EnumPeriod.period:
          final start = selectedRangePeriod?.start;
          final end = selectedRangePeriod?.end;

          if (start == null || end == null) return false;

          final normalizedStart = DateUtils.dateOnly(start);
          final normalizedEnd = DateUtils.dateOnly(end);

          return (expenseDate.isAtSameMomentAs(normalizedStart) ||
                  expenseDate.isAfter(normalizedStart)) &&
              (expenseDate.isAtSameMomentAs(normalizedEnd) ||
                  expenseDate.isBefore(normalizedEnd));
      }
    }).toList();
  });
});
