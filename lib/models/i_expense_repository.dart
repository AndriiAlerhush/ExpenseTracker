import 'package:expense_tracker/models/expense.dart';

abstract class IExpenseRepository {
  Stream<List<Expense>> getExpenses();
  Future<Expense?> getExpense(String id);
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(String id, Expense newExpenseData);
  Future<void> deleteExpense(String id);
  Future<void> restoreExpense(Expense expense);
}
