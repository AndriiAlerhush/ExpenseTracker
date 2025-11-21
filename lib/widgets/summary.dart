import 'package:expense_tracker/models/enum_period.dart';
import 'package:expense_tracker/providers/selected_period_provider.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/providers/daily_expenses_provider.dart';
import 'package:expense_tracker/providers/selected_date_provider.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utilities/formatters.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';

class Summary extends ConsumerWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredExpenses = ref.watch<List<Expense>>(dailyExpensesProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedPeriod = ref.watch<EnumPeriod>(selectedPeriodProvider);

    final sum = filteredExpenses.fold(
      0.0,
      (currentSum, expense) => currentSum += expense.amount,
    );

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
                onSelectionChanged: (Set<EnumPeriod> newSelection) {
                  ref
                      .read(selectedPeriodProvider.notifier)
                      .set(newSelection.first);
                },
                showSelectedIcon: false,
              ),
              const SizedBox(height: 6),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        ref
                            .read(selectedDateProvider.notifier)
                            .substract(const Duration(days: 1));
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(_getDate(selectedDate)),
                  ),
                  if (selectedDate.isBefore(
                    DateTime.now().subtract(const Duration(days: 1)),
                  ))
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          ref
                              .read(selectedDateProvider.notifier)
                              .add(const Duration(days: 1));
                        },
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  if (selectedDate.isBefore(
                    DateTime.now().subtract(const Duration(days: 1)),
                  ))
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
              // const SizedBox(height: 12),
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    "${amountFormat(sum)} RON",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
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

  String _getDate(DateTime date) {
    DateTime todayDate = DateUtils.dateOnly(DateTime.now());
    DateTime yesterdayDate = DateUtils.dateOnly(
      DateTime.now(),
    ).subtract(const Duration(days: 1));
    DateTime normalizedDate = DateUtils.dateOnly(date);

    String prefix = "";

    if (normalizedDate == todayDate) {
      prefix = "Today, ";
    }

    if (normalizedDate == yesterdayDate) {
      prefix = "Yesterday, ";
    }

    String finalDate = "$prefix${formatDate(date, [dd, ' ', MM, ' ', yyyy])}";

    return finalDate;
  }
}
