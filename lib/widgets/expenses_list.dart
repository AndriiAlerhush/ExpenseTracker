import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/utilities/dialog_utils.dart';
import 'package:expense_tracker/providers/expense_controller_provider.dart';
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
          key: ValueKey(_expenses[index].id),
          direction: DismissDirection.endToStart,
          background: Padding(
            padding: const EdgeInsets.only(
              right: 16,
              bottom: 12,
              left: 16,
            ),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.error.withAlpha(215),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          confirmDismiss: (direction) async {
            return await showDeleteConfirmDialog(context);
          },
          onDismissed: (direction) {
            final expense = _expenses[index];
            ref
                .read(expenseControllerProvider.notifier)
                .deleteExpense(expense.id);
            _showSnackBar(ref, expense);
          },
          child: ExpenseListItem(
            expense: _expenses[index],
            percentage: percentage,
            onTap: () async {
              await _showExpenseScreen(ctx, ref, _expenses[index]);
            },
          ),
        );
      },
    );
  }

  Future<void> _showExpenseScreen(
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

    ref.read(expenseControllerProvider.notifier).deleteExpense(expense.id);

    _showSnackBar(ref, expense);
  }

  void _showSnackBar(WidgetRef ref, Expense expense) {
    final notifier = ref.read(expenseControllerProvider.notifier);

    scaffoldMessengerKey.currentState?.clearSnackBars();

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Expense deleted."),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                notifier.restoreExpense(expense);
                scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
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
