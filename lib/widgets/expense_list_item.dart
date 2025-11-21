import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/color_categories.dart';
import 'package:expense_tracker/models/icon_categories.dart';
import 'package:expense_tracker/utilities/formatters.dart';

class ExpenseListItem extends StatelessWidget {
  const ExpenseListItem({
    super.key,
    required Expense expense,
    required double percentage,
  }) : _percentage = percentage,
       _expense = expense;

  final Expense _expense;
  final double _percentage;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: ListTile(
        leading: Icon(
          iconCategories[_expense.category],
          color: colorCategories[_expense.category],
        ),
        title: Text(
          capitalize(_expense.category.name),
          style: Theme.of(context).textTheme.bodyLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: _expense.comment == null
            ? null
            : SizedBox(
                width: 10,
                child: Text(
                  _expense.comment!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        trailing: SizedBox(
          width: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${_percentage.round()}%".padLeft(4),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "${amountFormat(_expense.amount)} RON",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
