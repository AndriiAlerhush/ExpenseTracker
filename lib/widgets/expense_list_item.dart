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
    required void Function()? onTap,
  }) : _onTap = onTap,
       _percentage = percentage,
       _expense = expense;

  final Expense _expense;
  final double _percentage;
  final void Function()? _onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.25,
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: InkWell(
        onTap: _onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              Icon(
                iconCategories[_expense.category],
                color: colorCategories[_expense.category],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalize(_expense.category.name),
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (_expense.comment != null)
                      Text(
                        _expense.comment!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${amountFormat(_expense.amount)} RON",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "${_percentage.round()}%",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return Card(
  //     margin: const EdgeInsets.only(
  //       left: 16,
  //       right: 16,
  //       bottom: 12,
  //     ),
  //     child: InkWell(
  //       onTap: _onTap,
  //       splashFactory: NoSplash.splashFactory,
  //       highlightColor: Colors.transparent,
  //       child: ListTile(
  //         leading: Icon(
  //           iconCategories[_expense.category],
  //           color: colorCategories[_expense.category],
  //         ),
  //         title: Text(
  //           capitalize(_expense.category.name),
  //           style: Theme.of(context).textTheme.bodyLarge,
  //           maxLines: 1,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         subtitle: _expense.comment == null
  //             ? null
  //             : SizedBox(
  //                 width: 10,
  //                 child: Text(
  //                   _expense.comment!,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //         trailing: SizedBox(
  //           width: 140,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 "${_percentage.round()}%".padLeft(4),
  //                 style: Theme.of(context).textTheme.bodyLarge,
  //               ),
  //               Text(
  //                 "${amountFormat(_expense.amount)} RON",
  //                 style: Theme.of(context).textTheme.bodyLarge,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
