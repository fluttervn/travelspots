import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// A class defines exception type
enum ExceptionType {
  /// Response type
  Response,

  /// Network type
  Network,

  /// Token expire type
  TokenExpire,

  /// Login error: subCode = 0: Invalid username or password
  LoginInvalidUsernameOrPassword,

  /// Login error: subCode = 1: This organization not active
  LoginOrganizationNotActive,

  /// Login error: subCode = 2: This account not active
  LoginAccountNotActive,

  /// Login error: subCode = -1: user is requesting to change password
  LoginUserIsChangingPassword,

  /// Login error: subCode = -2: user is being suspended
  LoginUserIsSuspended,

  /// Login error: subCode = -3: user is requesting to change email
  LoginUserIsChangingEmail,

  /// Login error: subCode = 1: Organization not found
  LoginOrganizationNotFound,

  /// Login error: subCode = 2: User not found
  LoginUserNotFound,
}

/// Utility class help handle data exception
class ExceptionHelper {
  /// Create new instance of FltException from any kind from error
  static FltException newInstance(dynamic e, {String endpoint}) {
    if (e is InvalidUserException) return e;

    if (e is FltException) return e;

    if (e is String) return FltException(message: e);

    if (e is PlatformException) {
      return FltException(code: e.code, message: e.message);
    }

    if (e is Map<String, dynamic>) {
      // http success (200/201) but error data
      return FltException(
          code: e['code'], message: e['errors']['message'], info: e);
    }

    return FltException(message: e.toString());
  }
}

/// A common exception for app
class FltException implements Exception {
  /// code error
  final dynamic code;

  /// message error
  final dynamic message;

  /// endpoint
  final String endpoint;

  /// info
  final dynamic info;

  /// exception type
  final ExceptionType type;

  /// Constructor flt exception
  FltException({this.code, this.type, this.message, this.endpoint, this.info});

  @override
  String toString() {
    return 'FlException{code: $code, $type: message: $message, info: $info}';
  }

  /// Localization language
  String get localizeMessage {
    var _localMessage = message;
    switch (type) {
      case ExceptionType.LoginInvalidUsernameOrPassword:
        return _localMessage = translate('login_invalid_username_or_password');
        break;
      case ExceptionType.LoginOrganizationNotActive:
        return _localMessage = translate('login_organization_not_active');
        break;
      case ExceptionType.LoginAccountNotActive:
        return _localMessage = translate('login_account_not_active');
        break;
      case ExceptionType.LoginUserIsChangingPassword:
        return _localMessage = translate('login_user_is_changing_password');
        break;
      case ExceptionType.LoginUserIsSuspended:
        return _localMessage = translate('login_user_is_suspended');
        break;
      case ExceptionType.LoginUserIsChangingEmail:
        return _localMessage = translate('login_user_is_changing_email');
        break;
      case ExceptionType.LoginOrganizationNotFound:
        return _localMessage = translate('login_organization_not_found');
        break;
      case ExceptionType.LoginUserNotFound:
        return _localMessage = translate('login_user_not_found');
        break;
      case ExceptionType.Network:
        _localMessage = translate('error_no_internet');
        break;
      default:
        break;
    }
    return _localMessage;
  }
}

/// Class contain user exception info
class InvalidUserException extends FltException {
  /// detail exception
  final String detail;

  /// message exception
  final String message;

  /// Constructor InvalidUserException
  InvalidUserException({
    this.message = 'Invalid user',
    this.detail,
  });

  String toString() {
    return "InvalidTokenException{message: $message, detail: $detail}";
  }
}

/// Class contain timeout info
class ConnectionTimeoutException extends FltException {
  /// message exception
  final String message;

  /// detail exception
  final String detail;

  /// Constructor ConnectionTimeoutException
  ConnectionTimeoutException({
    this.message = 'Cannot connect to server',
    this.detail,
  });

  @override
  String toString() {
    return 'ConnectionTimeoutException{message: $message, detail: $detail}';
  }
}
