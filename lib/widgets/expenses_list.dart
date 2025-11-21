import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/utilities/dialog_utils.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/screens/expense_screen.dart';
import 'package:expense_tracker/widgets/expense_list_item.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpensesList extends ConsumerWidget {
  const ExpensesList({
    super.key,
    required List<Expense> expenses,
  }) : _expenses = expenses;

  final List<Expense> _expenses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double sum = _expenses.fold(
      0.0,
      (currentSum, expense) => currentSum += expense.amount,
    );

    return ListView.builder(
      itemCount: _expenses.length,
      itemBuilder: (ctx, index) {
        double percentage = 0.0;

        if (sum > 0) {
          percentage = _expenses[index].amount * 100 / sum;
        }

        return Dismissible(
          key: Key(_expenses[index].id.toString()),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDeleteConfirmDialog(context);
          },
          onDismissed: (direction) {
            final expense = _expenses[index];
            ref.read(expensesProvider.notifier).deleteExpense(expense);
            _showSnackBar(context, ref, expense);
          },
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            onTap: () {
              _showExpenseScreen(ctx, ref, _expenses[index]);
            },
            child: ExpenseListItem(
              expense: _expenses[index],
              percentage: percentage,
            ),
          ),
        );
      },
    );
  }

  void _showExpenseScreen(
    BuildContext context,
    WidgetRef ref,
    Expense expense,
  ) async {
    final shouldDelete =
        await Navigator.of(
          context,
        ).push<bool>(
          MaterialPageRoute(
            builder: (ctx) => ExpenseScreen(
              expense: expense,
            ),
          ),
        );

    if (shouldDelete == null || !shouldDelete || !context.mounted) return;

    ref.read(expensesProvider.notifier).deleteExpense(expense);
    _showSnackBar(context, ref, expense);
  }

  void _showSnackBar(BuildContext context, WidgetRef ref, Expense expense) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text("Expense deleted."),
            Spacer(),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();

                ref.read(expensesProvider.notifier).addExpense(expense);

                ScaffoldMessenger.of(
                  context,
                ).hideCurrentSnackBar();
              },
              child: const Text("Undo"),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
