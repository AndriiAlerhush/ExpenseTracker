import 'package:expense_tracker/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseNotifier extends Notifier<List<Expense>> {
  @override
  List<Expense> build() {
    return [];
  }

  void addExpense(Expense expense) {
    state = [...state, expense];
  }

  void deleteExpense(Expense expense) {
    state = state.where((exp) => exp.id != expense.id).toList();
  }
}

final expensesProvider = NotifierProvider<ExpenseNotifier, List<Expense>>(
  ExpenseNotifier.new,
);
