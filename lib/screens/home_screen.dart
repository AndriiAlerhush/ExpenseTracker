import 'package:flutter/material.dart';
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
    final filteredExpenses = ref.watch<AsyncValue<List<Expense>>>(
      selectedPeriodExpenseProvider,
    );

    Widget content = filteredExpenses.when(
      data: (expenses) {
        if (expenses.isEmpty) {
          return Expanded(
            child: Center(
              child: Text(
                "No expenses for the selected period.",
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
        return const Text("ERROR");
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
        // backgroundColor: Colors.lightGreen,
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
          const SizedBox(height: 16),
          const Summary(),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
}
