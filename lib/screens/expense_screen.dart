import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:expense_tracker/models/color_categories.dart';
import 'package:expense_tracker/models/icon_categories.dart';
import 'package:expense_tracker/utilities/formatters.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utilities/dialog_utils.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({
    super.key,
    required Expense expense,
  }) : _expense = expense;

  final Expense _expense;

  @override
  Widget build(BuildContext context) {
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
                  const Text("Amount"),
                  Text("${amountFormat(_expense.amount)} RON"),
                  const SizedBox(height: 24),
                  const Text("Category"),
                  Row(
                    children: [
                      Icon(
                        iconCategories[_expense.category],
                        color: colorCategories[_expense.category],
                      ),
                      const SizedBox(width: 8),
                      Text(capitalize(_expense.category.name)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("Date"),
                  Text(formatDate(_expense.date, [dd, ' ', MM, ' ', yyyy])),
                  const SizedBox(height: 24),
                  const Text("Created At"),
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
                  ),
                  if (_expense.comment != null) const SizedBox(height: 24),
                  if (_expense.comment != null) const Text("Comment"),
                  if (_expense.comment != null) Text(_expense.comment!),
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
