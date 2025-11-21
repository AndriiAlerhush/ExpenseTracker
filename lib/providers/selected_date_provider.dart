import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void substract(final Duration duration) {
    state = state.subtract(duration);
  }

  void add(final Duration duration) {
    state = state.add(duration);
  }

  void set(final DateTime date) {
    state = date;
  }
}

final selectedDateProvider = NotifierProvider<DateNotifier, DateTime>(
  DateNotifier.new,
);
