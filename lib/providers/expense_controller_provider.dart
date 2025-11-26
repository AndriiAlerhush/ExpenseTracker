import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/repository_provider.dart';

class ExpenseController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> addExpense(Expense expense) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(expenseRepositoryProvider);
      await repository.addExpense(expense);
    });
  }

  Future<void> updateExpense(String id, Expense expenseNewData) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(expenseRepositoryProvider);
      await repository.updateExpense(id, expenseNewData);
    });
  }

  Future<void> deleteExpense(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(expenseRepositoryProvider);
      await repository.deleteExpense(id);
    });
  }

  Future<void> restoreExpense(Expense expense) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(expenseRepositoryProvider);
      await repository.restoreExpense(expense);
    });
  }
}

final expenseControllerProvider =
    AsyncNotifierProvider<ExpenseController, void>(ExpenseController.new);
