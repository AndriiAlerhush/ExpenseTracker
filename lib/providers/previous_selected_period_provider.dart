import 'package:expense_tracker/models/enum_period.dart';
import 'package:flutter_riverpod/legacy.dart';

final previousSelectedPeriodProvider = StateProvider<EnumPeriod>((ref) {
  return EnumPeriod.day;
});
