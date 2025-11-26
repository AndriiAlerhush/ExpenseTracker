import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseListProvider = StreamProvider<List<Expense>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getExpenses();
});
