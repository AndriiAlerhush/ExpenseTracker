import 'dart:async';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/i_expense_crud.dart';

class MockExpenseRepository implements IExpenseCRUD {
  final List<Expense> _mockStorage = [];
  final _controller = StreamController<List<Expense>>.broadcast();

  final Duration _crudDelay = const Duration(milliseconds: 100);
  final Duration _initialLoadDelay = const Duration(milliseconds: 5000);

  bool _initialLoadComplete = false;

  MockExpenseRepository({List<Expense>? initialData}) {
    if (initialData != null) {
      _mockStorage.addAll(initialData);
    }
  }

  void _emitUpdate() {
    _controller.add(List.from(_mockStorage));
  }

  @override
  Stream<List<Expense>> getExpenses() {
    if (!_initialLoadComplete) {
      Future.delayed(_initialLoadDelay, () {
        _initialLoadComplete = true;
        _emitUpdate();
      });
    } else {
      Future.microtask(_emitUpdate);
    }

    return _controller.stream;
  }

  @override
  Future<Expense?> getExpense(String id) async {
    await Future.delayed(_crudDelay);
    try {
      return _mockStorage.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addExpense(Expense expense) async {
    await Future.delayed(_crudDelay);

    final expenseToSave = expense.id.isEmpty
        ? Expense(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            comment: expense.comment,
            amount: expense.amount,
            date: expense.date,
            createdAt: expense.createdAt,
            category: expense.category,
          )
        : expense;

    _mockStorage.add(expenseToSave);
    _emitUpdate();
  }

  @override
  Future<void> updateExpense(String id, Expense newExpenseData) async {
    await Future.delayed(_crudDelay);

    final index = _mockStorage.indexWhere((element) => element.id == id);

    if (index != -1) {
      _mockStorage[index] = newExpenseData;
      _emitUpdate();
    } else {
      throw Exception("Expense with id $id not found in Mock DB");
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    await Future.delayed(_crudDelay);

    _mockStorage.removeWhere((element) => element.id == id);
    _emitUpdate();
  }

  @override
  Future<void> restoreExpense(Expense expense) async {
    await Future.delayed(_crudDelay);

    final index = _mockStorage.indexWhere(
      (element) => element.id == expense.id,
    );

    if (index != -1) {
      _mockStorage[index] = expense;
    } else {
      _mockStorage.add(expense);
    }
    _emitUpdate();
  }

  void dispose() {
    _controller.close();
  }
}
