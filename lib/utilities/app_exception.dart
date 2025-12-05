import 'package:firebase_core/firebase_core.dart';

class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException() : super("Please check your internet connection.");
}

class PermissionException extends AppException {
  const PermissionException()
    : super("You do not have permission to perform this action.");
}

Future<T> errorHandler<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on FirebaseException catch (e) {
    if (e.code == 'permission-denied') {
      throw PermissionException();
    } else if (e.code == 'unavailable') {
      throw NetworkException();
    } else {
      throw AppException("Unknown error: ${e.message}");
    }
  } catch (e) {
    throw AppException("Something went wrong. Please try again.");
  }
}
