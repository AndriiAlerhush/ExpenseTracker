import 'package:expense_tracker/models/enum_categories.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/models/i_expense_crud.dart';
import 'package:expense_tracker/repositories/mock_expense_repository.dart';

final expenseRepositoryProvider = Provider<IExpenseCRUD>((ref) {
  // return FBExpenseRepository(FirebaseFirestore.instance);
  return MockExpenseRepository(
    initialData: [
      Expense(
        id: '1',
        comment: 'Test Pizza',
        amount: 45.5,
        date: DateTime.now(),
        createdAt: DateTime.now(),
        category: Category.food,
      ),
      Expense(
        id: '2',
        comment: 'Test Uber',
        amount: 20.0,
        date: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now(),
        category: Category.shopping,
      ),
    ],
  );
});
