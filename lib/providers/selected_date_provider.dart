import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:expense_tracker/models/enum_period.dart';

class DateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateUtils.dateOnly(DateTime.now());

  void set(DateTime date) => state = DateUtils.dateOnly(date);

  void navigate(int direction, EnumPeriod period) {
    switch (period) {
      case EnumPeriod.day:
        state = state.add(Duration(days: 1 * direction));
        break;

      case EnumPeriod.week:
        state = state.add(Duration(days: 7 * direction));
        break;

      case EnumPeriod.month:
        final newMonth = state.month + direction;
        state = DateTime(state.year, newMonth, 1);
        break;

      case EnumPeriod.year:
        state = DateTime(state.year + direction, state.month, state.day);
        break;

      case EnumPeriod.period:
        state = state.add(Duration(days: 1 * direction));
        break;
    }
  }
}

final selectedDateProvider = NotifierProvider<DateNotifier, DateTime>(
  DateNotifier.new,
);

final selectedRangeProvider = StateProvider<DateTimeRange?>((ref) => null);
