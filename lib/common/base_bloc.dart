import 'package:fimber/fimber.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

/// enum BaseBlocProperties
enum BaseBlocProperties {
  /// loading state
  loading,

  /// error state
  serverError,

  /// server success state
  serverSuccess,

  /// local error state
  localError,

  /// local success state
  localSuccess,
}

/// Creating base bloc to manage all bloc
class BaseBloc<T extends Object> extends PropertyChangeNotifier<T> {
  /// Force cancel task
  bool forceCancel = false;

  /// Properties for Sever success and error
  static const List<BaseBlocProperties> propServerSuccessError = [
    BaseBlocProperties.serverError,
    BaseBlocProperties.serverSuccess,
  ];

  /// Properties for Sever loading, success and error
  static const List<BaseBlocProperties> propServerLoadingSuccessError = [
    BaseBlocProperties.loading,
    BaseBlocProperties.serverError,
    BaseBlocProperties.serverSuccess,
  ];

  /// Cancelling a task when requesting api
  Future<Null> handleCancelTask({String from}) async {
    Fimber.d('force cancel $from');
    forceCancel = false;
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// Creating base bloc to manage all bloc
class FltBloc extends PropertyChangeNotifier<BaseBlocProperties> {
  /// Force cancel task
  bool forceCancel = false;

  /// Properties for Sever success and error
  static const List<BaseBlocProperties> propServerSuccessError = [
    BaseBlocProperties.serverError,
    BaseBlocProperties.serverSuccess,
  ];

  /// Properties for Sever loading, success and error
  static const List<BaseBlocProperties> propServerLoadingSuccessError = [
    BaseBlocProperties.loading,
    BaseBlocProperties.serverError,
    BaseBlocProperties.serverSuccess,
  ];

  /// Cancelling a task when requesting api
  Future<Null> handleCancelTask({String from}) async {
    Fimber.d('force cancel $from');
    forceCancel = false;
    return null;
  }

  /// Notify that server request is successful
  void notifyServerSuccess() {
    notifyListeners(BaseBlocProperties.serverSuccess);
  }

  /// Notify that server request is failed
  void notifyServerError() {
    notifyListeners(BaseBlocProperties.serverError);
  }

  /// Notify that server request is in progress
  void notifyInProgress() {
    notifyListeners(BaseBlocProperties.loading);
  }
}
