// import 'package:expense_tracker/models/expense.dart';
// import 'package:expense_tracker/models/i_expense_crud.dart';
// import 'package:expense_tracker/utilities/app_exception.dart';

// class FBExpenseRepository implements IExpenseCRUD {
//   final FirebaseFirestore _firestore;

//   const FBExpenseRepository(this._firestore);

//   @override
//   Stream<List<Expense>> getExpenses() {
//     return _firestore
//         .collection('expenses')
//         .snapshots()
//         .handleError((error) {
//           if (error is FirebaseException) {
//             if (error.code == 'permission-denied') {
//               throw PermissionException();
//             } else if (error.code == 'unavailable') {
//               throw NetworkException();
//             }
//           }
//           throw AppException("Error loading data.");
//         })
//         .map((snapshot) {
//           return snapshot.docs
//               .map((doc) => Expense.fromMap(doc.data(), doc.id))
//               .toList();
//         });
//   }

//   @override
//   Future<Expense?> getExpense(String id) async {
//     return await errorHandler(() async {
//       var docSnapshot = await _firestore.collection('expenses').doc(id).get();

//       if (!docSnapshot.exists) {
//         return null;
//       }

//       return Expense.fromMap(docSnapshot.data()!, docSnapshot.id);
//     });
//   }

//   @override
//   Future<void> addExpense(Expense expense) async {
//     await errorHandler(() async {
//       await _firestore.collection('expenses').add(expense.toMap());
//     });
//   }

//   @override
//   Future<void> updateExpense(String id, Expense newExpenseData) async {
//     await errorHandler(() async {
//       await _firestore
//           .collection('expenses')
//           .doc(id)
//           .set(newExpenseData.toMap());
//     });
//   }

//   @override
//   Future<void> deleteExpense(String id) async {
//     await errorHandler(() async {
//       await _firestore.collection('expenses').doc(id).delete();
//     });
//   }

//   @override
//   Future<void> restoreExpense(Expense expense) async {
//     await errorHandler(() async {
//       await _firestore
//           .collection('expenses')
//           .doc(expense.id)
//           .set(expense.toMap());
//     });
//   }
// }
