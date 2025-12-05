import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/providers/selected_date_provider.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/models/color_categories.dart';
import 'package:expense_tracker/models/icon_categories.dart';
import 'package:expense_tracker/utilities/formatters.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utilities/dialog_utils.dart';

class ExpenseScreen extends ConsumerWidget {
  const ExpenseScreen({
    super.key,
    required Expense expense,
  }) : _expense = expense;

  final Expense _expense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch<DateTime>(selectedDateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expense Details",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(
                  MaterialPageRoute(
                    builder: (ctx) => AddExpenseScreen(
                      expense: _expense,
                      selectedDate: selectedDate,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              // color: Colors.lightGreen,
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              // height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amount",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${amountFormat(_expense.amount)} RON",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Category",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        iconCategories[_expense.category],
                        color: colorCategories[_expense.category],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        capitalize(_expense.category.name),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Date",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formatDate(_expense.date, [dd, ' ', MM, ' ', yyyy]),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Created At",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formatDate(_expense.createdAt, [
                      dd,
                      ' ',
                      MM,
                      ' ',
                      yyyy,
                      ', ',
                      H,
                      ':',
                      nn,
                    ]),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (_expense.comment != null) const SizedBox(height: 24),
                  if (_expense.comment != null)
                    Text(
                      "Comment",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (_expense.comment != null)
                    Text(
                      _expense.comment!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () async {
                      HapticFeedback.lightImpact();
                      final shoudlDelete = await showDeleteConfirmDialog(
                        context,
                      );

                      if (shoudlDelete && context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    },
                    child: Text(
                      "DELETE",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
