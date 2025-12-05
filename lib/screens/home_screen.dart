import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/providers/selected_period_expenses_provider.dart';
import 'package:expense_tracker/widgets/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/drawer.dart';
import 'package:expense_tracker/widgets/summary.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<List<Expense>>>(
      selectedPeriodExpenseProvider,
      (previous, next) {
        if (next.hasError && !next.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error.toString()),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.red,
                onPressed: () {
                  ref.invalidate(selectedPeriodExpenseProvider);
                },
              ),
              showCloseIcon: true,
            ),
          );
        }
      },
    );

    final filteredExpenses = ref.watch<AsyncValue<List<Expense>>>(
      selectedPeriodExpenseProvider,
    );

    Widget content = filteredExpenses.when(
      data: (expenses) {
        if (expenses.isEmpty) {
          return Expanded(
            child: Center(
              child: Text(
                "No expenses for this period.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        } else {
          return Expanded(
            child: ExpensesList(expenses: expenses),
          );
        }
      },
      error: (error, stackTrace) {
        return Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Something went wrong.",
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.invalidate(selectedPeriodExpenseProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Try Again"),
                ),
              ],
            ),
          ),
        );
      },
      loading: () {
        return Expanded(
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expense Tracker",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              Scaffold.of(ctx).openDrawer();
            },
          ),
        ),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                ),
                child: const Summary(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
}
