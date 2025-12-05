import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/i_expense_crud.dart';
import 'package:expense_tracker/utilities/app_exception.dart';

class FBExpenseRepository implements IExpenseCRUD {
  final FirebaseFirestore _firestore;
  final String _uid;

  const FBExpenseRepository(this._firestore, this._uid);

  CollectionReference get _userExpensesCollection =>
      _firestore.collection('users').doc(_uid).collection('expenses');

  @override
  Stream<List<Expense>> getExpenses() {
    return _userExpensesCollection
        .snapshots()
        .handleError((error) {
          if (error is FirebaseException) {
            if (error.code == 'permission-denied') {
              throw PermissionException();
            } else if (error.code == 'unavailable') {
              throw NetworkException();
            }
          }
          throw AppException("Error loading data.");
        })
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Expense.fromMap(data, doc.id);
          }).toList();
        });
  }

  @override
  Future<Expense?> getExpense(String id) async {
    return await errorHandler(() async {
      var docSnapshot = await _userExpensesCollection.doc(id).get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return null;
      }

      final data = docSnapshot.data() as Map<String, dynamic>;

      return Expense.fromMap(data, docSnapshot.id);
    });
  }

  @override
  Future<void> addExpense(Expense expense) async {
    await errorHandler(() async {
      await _userExpensesCollection.add(expense.toMap());
    });
  }

  @override
  Future<void> updateExpense(String id, Expense newExpenseData) async {
    await errorHandler(() async {
      await _userExpensesCollection.doc(id).set(newExpenseData.toMap());
    });
  }

  @override
  Future<void> deleteExpense(String id) async {
    await errorHandler(() async {
      await _userExpensesCollection.doc(id).delete();
    });
  }

  @override
  Future<void> restoreExpense(Expense expense) async {
    await errorHandler(() async {
      await _userExpensesCollection.doc(expense.id).set(expense.toMap());
    });
  }
}
