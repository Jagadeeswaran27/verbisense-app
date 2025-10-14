import 'package:verbisense/core/resources/strings/google_signin_error_strings.dart';

enum GoogleSignInErrorCode {
  canceled('canceled'),
  clientConfigurationError('client-configuration-error'),
  interrupted('interrupted'),
  uiUnavailable('ui-unavailable'),
  networkError('network-error'),
  unknownError('unknown-error'),
  signInRequired('sign-in-required'),
  signInFailed('sign-in-failed');

  const GoogleSignInErrorCode(this.code);
  final String code;
}

extension GoogleSignInErrorCodeX on GoogleSignInErrorCode {
  static GoogleSignInErrorCode? fromCode(String code) {
    try {
      return GoogleSignInErrorCode.values.firstWhere(
        (errorCode) => errorCode.code == code,
      );
    } catch (e) {
      return null;
    }
  }

  String get message {
    switch (this) {
      case GoogleSignInErrorCode.canceled:
        return GoogleSigninErrorStrings.canceled;
      case GoogleSignInErrorCode.clientConfigurationError:
        return GoogleSigninErrorStrings.clientConfigurationError;
      case GoogleSignInErrorCode.interrupted:
        return GoogleSigninErrorStrings.interrupted;
      case GoogleSignInErrorCode.uiUnavailable:
        return GoogleSigninErrorStrings.uiUnavailable;
      case GoogleSignInErrorCode.networkError:
        return GoogleSigninErrorStrings.networkError;
      case GoogleSignInErrorCode.signInRequired:
        return GoogleSigninErrorStrings.signInRequired;

      case GoogleSignInErrorCode.signInFailed:
        return 'Sign-in failed. Please try again';
      default:
        return 'An unknown error occurred during Google Sign-In';
    }
  }

  bool get isRetryable {
    switch (this) {
      case GoogleSignInErrorCode.networkError:
      case GoogleSignInErrorCode.uiUnavailable:
      case GoogleSignInErrorCode.interrupted:
        return true;
      default:
        return false;
    }
  }
}
