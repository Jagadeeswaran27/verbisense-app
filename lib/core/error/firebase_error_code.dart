import 'package:verbisense/core/resources/firebase_error_strings.dart';

enum FirebaseErrorCode {
  alreadyExists('already-exists'),
  invalidArgument('invalid-argument'),
  internal('internal'),
  invalidCredential('invalid-credential'),
  userDisabled('user-disabled'),
  userNotFound('user-not-found'),
  wrongPassword('wrong-password'),
  accountExistsWithDifferentCredential(
    'account-exists-with-different-credential',
  ),
  operationNotAllowed('operation-not-allowed'),
  networkRequestFailed('network-request-failed');

  const FirebaseErrorCode(this.code);

  final String code;
}

extension FirebaseErroCodeX on FirebaseErrorCode {
  static FirebaseErrorCode? fromCode(String code) {
    try {
      return FirebaseErrorCode.values.firstWhere(
        (errorCode) => errorCode.code == code,
      );
    } catch (e) {
      return null;
    }
  }

  String get message {
    switch (this) {
      case FirebaseErrorCode.alreadyExists:
        return FirebaseErrorStrings.alreadyExists;
      case FirebaseErrorCode.operationNotAllowed:
        return FirebaseErrorStrings.operationNotAllowed;
      case FirebaseErrorCode.internal:
        return FirebaseErrorStrings.internal;
      case FirebaseErrorCode.invalidArgument:
        return FirebaseErrorStrings.invalidArgument;
      case FirebaseErrorCode.accountExistsWithDifferentCredential:
        return FirebaseErrorStrings.accountExistsWithDifferentCredential;
      case FirebaseErrorCode.userNotFound:
        return FirebaseErrorStrings.userNotFound;
      case FirebaseErrorCode.wrongPassword:
        return FirebaseErrorStrings.wrongPassword;
      case FirebaseErrorCode.userDisabled:
        return FirebaseErrorStrings.userDisabled;
      case FirebaseErrorCode.invalidCredential:
        return FirebaseErrorStrings.invalidCredential;
      case FirebaseErrorCode.networkRequestFailed:
        return 'Network error';
    }
  }
}
