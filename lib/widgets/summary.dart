import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/providers/previous_selected_period_provider.dart';
import 'package:expense_tracker/models/enum_period.dart';
import 'package:expense_tracker/providers/selected_period_provider.dart';
import 'package:expense_tracker/providers/selected_period_expenses_provider.dart';
import 'package:expense_tracker/providers/selected_date_provider.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utilities/formatters.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';

class Summary extends ConsumerWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredExpenses = ref.watch<AsyncValue<List<Expense>>>(
      selectedPeriodExpenseProvider,
    );
    final selectedDate = ref.watch<DateTime>(selectedDateProvider);
    final selectedPeriod = ref.watch<EnumPeriod>(selectedPeriodProvider);
    final selectedDateRange = ref.watch<DateTimeRange?>(selectedRangeProvider);

    final sumWidget = filteredExpenses.when(
      data: (expenses) {
        final sum = expenses.fold(
          0.0,
          (currentSum, expense) => currentSum += expense.amount,
        );

        return Text(
          key: Key(sum.toString()),
          "${amountFormat(sum)} RON",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        );
      },
      loading: () => const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (error, stack) => Text(
        "Error",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      skipLoadingOnReload: true,
    );

    final date = _getDate(selectedDate, selectedPeriod, selectedDateRange);

    return Card(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      child: Container(
        height: 180,
        width: double.infinity,
        alignment: AlignmentGeometry.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SegmentedButton<EnumPeriod>(
                segments: [
                  ButtonSegment(
                    value: EnumPeriod.day,
                    label: Text(capitalize(EnumPeriod.day.name)),
                  ),
                  ButtonSegment(
                    value: EnumPeriod.week,
                    label: Text(capitalize(EnumPeriod.week.name)),
                  ),
                  ButtonSegment(
                    value: EnumPeriod.month,
                    label: Text(capitalize(EnumPeriod.month.name)),
                  ),
                  ButtonSegment(
                    value: EnumPeriod.year,
                    label: Text(capitalize(EnumPeriod.year.name)),
                  ),
                  ButtonSegment(
                    value: EnumPeriod.period,
                    label: Text(capitalize(EnumPeriod.period.name)),
                  ),
                ],
                selected: {selectedPeriod},
                onSelectionChanged: (Set<EnumPeriod> newSelection) async {
                  final clickedPeriod = newSelection.first;
                  await _onChangedPeriodSelection(context, ref, clickedPeriod);
                },
                showSelectedIcon: false,
              ),
              const SizedBox(height: 6),
              Stack(
                alignment: Alignment.center,
                children: [
                  if (selectedPeriod != EnumPeriod.period)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          ref
                              .read(selectedDateProvider.notifier)
                              .navigate(-1, selectedPeriod);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                  TextButton(
                    onPressed: () async {
                      await _showDatePicker(context, ref);
                    },
                    child: Text(
                      date,
                      key: ValueKey(date),
                    ),
                  ),
                  if (selectedPeriod != EnumPeriod.period &&
                      _canGoNext(selectedDate, selectedPeriod))
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          ref
                              .read(selectedDateProvider.notifier)
                              .navigate(1, selectedPeriod);
                        },
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  if (selectedPeriod != EnumPeriod.period &&
                      _canGoNext(selectedDate, selectedPeriod))
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            ref
                                .read(selectedDateProvider.notifier)
                                .set(DateTime.now());
                          },
                          icon: const Icon(Icons.keyboard_double_arrow_right),
                        ),
                      ),
                    ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  sumWidget,
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(
                            20,
                          ),
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          _showAddExpenseScreen(context);
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddExpenseScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(
      MaterialPageRoute(
        builder: (ctx) => AddExpenseScreen(),
      ),
    );
  }

  String _getDate(
    DateTime date,
    EnumPeriod period,
    DateTimeRange? range,
  ) {
    final normalizedDate = DateUtils.dateOnly(date);

    if (period == EnumPeriod.month) {
      return formatDate(normalizedDate, [MM, ' ', yyyy]);
    }
    if (period == EnumPeriod.year) {
      return formatDate(normalizedDate, [yyyy]);
    }
    if (period == EnumPeriod.week) {
      final startOfWeek = normalizedDate.subtract(
        Duration(days: normalizedDate.weekday - 1),
      );

      final endOfWeek = normalizedDate.add(
        Duration(days: 7 - normalizedDate.weekday),
      );

      return "${formatDate(startOfWeek, [dd, ' ', M])} - ${formatDate(endOfWeek, [dd, ' ', M])}, ${normalizedDate.year}";
    }
    if (period == EnumPeriod.period) {
      if (range == null) return "";

      final startDate = range.start;
      final endDate = range.end;

      return "${formatDate(startDate, [dd, ' ', M])} - ${formatDate(endDate, [dd, ' ', M])}, ${normalizedDate.year}";
    }

    // Day
    DateTime todayDate = DateUtils.dateOnly(DateTime.now());
    DateTime yesterdayDate = DateUtils.dateOnly(
      DateTime.now(),
    ).subtract(const Duration(days: 1));

    String prefix = "";

    if (normalizedDate == todayDate) {
      prefix = "Today, ";
    }

    if (normalizedDate == yesterdayDate) {
      prefix = "Yesterday, ";
    }

    String result =
        "$prefix${formatDate(normalizedDate, [dd, ' ', MM, ' ', yyyy])}";

    return result;
  }

  bool _canGoNext(DateTime selectedDate, EnumPeriod selectedPeriod) {
    final normalizedSelectedDate = DateUtils.dateOnly(selectedDate);
    final normalizedToday = DateUtils.dateOnly(DateTime.now());

    switch (selectedPeriod) {
      case EnumPeriod.day:
        return normalizedSelectedDate.isBefore(normalizedToday);

      case EnumPeriod.week:
        final startOfCurrentWeek = normalizedToday.subtract(
          Duration(days: normalizedToday.weekday - 1),
        );

        final startOfSelectedWeek = normalizedSelectedDate.subtract(
          Duration(days: normalizedSelectedDate.weekday - 1),
        );

        return startOfSelectedWeek.isBefore(startOfCurrentWeek);

      case EnumPeriod.month:
        return (normalizedSelectedDate.year < normalizedToday.year) ||
            (normalizedSelectedDate.year == normalizedToday.year &&
                normalizedSelectedDate.month < normalizedToday.month);

      case EnumPeriod.year:
        return normalizedSelectedDate.year < normalizedToday.year;

      default:
        return normalizedSelectedDate.isBefore(normalizedToday);
    }
  }

  Future<DateTimeRange?> _showDateRangeTimePicker(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final now = DateTime.now();
    final initialRange = ref.read(selectedRangeProvider);

    return await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      locale: const Locale('en', 'GB'),
      initialDateRange: initialRange,
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final now = DateTime.now();
    final initialDate = ref.read(selectedDateProvider);
    final selectedPeriod = ref.read(selectedPeriodProvider);

    if (selectedPeriod == EnumPeriod.period) {
      final pickedRange = await _showDateRangeTimePicker(context, ref);

      if (pickedRange != null) {
        ref.read(selectedRangeProvider.notifier).state = pickedRange;
        ref.read(selectedDateProvider.notifier).set(pickedRange.start);
      } else {
        final previousPeriod = ref.read(previousSelectedPeriodProvider);
        ref.read(selectedRangeProvider.notifier).state = null;
        ref.read(selectedPeriodProvider.notifier).set(previousPeriod);
      }

      return;
    }

    DatePickerMode initialMode = DatePickerMode.day;

    String? helpText;

    if (selectedPeriod == EnumPeriod.week) {
      helpText = "Select any day in the desired week";
    } else if (selectedPeriod == EnumPeriod.month) {
      helpText = "Select any day in the desired month";
    } else if (selectedPeriod == EnumPeriod.year) {
      initialMode = DatePickerMode.year;
      helpText = "Select any day in the desired year";
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDatePickerMode: initialMode,
      helpText: helpText,
      locale: const Locale('en', 'GB'),
    );

    if (pickedDate != null) {
      ref.read(selectedDateProvider.notifier).set(pickedDate);
    }
  }

  Future<void> _onChangedPeriodSelection(
    BuildContext context,
    WidgetRef ref,
    EnumPeriod clickedPeriod,
  ) async {
    if (clickedPeriod == EnumPeriod.period) {
      final pickedRange = await _showDateRangeTimePicker(
        context,
        ref,
      );

      if (pickedRange == null) {
        ref.read(selectedRangeProvider.notifier).state = null;
        return;
      }

      ref.read(selectedRangeProvider.notifier).state = pickedRange;
      ref.read(selectedDateProvider.notifier).set(pickedRange.start);
      ref.read(selectedPeriodProvider.notifier).set(EnumPeriod.period);
    } else {
      final currentActivePeriod = ref.read(
        selectedPeriodProvider,
      );

      if (currentActivePeriod == EnumPeriod.period) {
        ref.read(selectedDateProvider.notifier).set(DateTime.now());
      }

      ref.read(selectedPeriodProvider.notifier).set(clickedPeriod);
    }
  }
}
