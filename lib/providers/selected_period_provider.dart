import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/models/enum_period.dart';

class PeriodNotifier extends Notifier<EnumPeriod> {
  @override
  EnumPeriod build() {
    return EnumPeriod.day;
  }

  void set(final EnumPeriod period) {
    state = period;
  }
}

final selectedPeriodProvider = NotifierProvider<PeriodNotifier, EnumPeriod>(
  PeriodNotifier.new,
);
