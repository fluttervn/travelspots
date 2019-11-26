import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';

/// [SharedData] is a helper class to store shared data in global scope. For
/// example [BuildContext], [TokenBloc]
class SharedData {
  // singleton
  static SharedData _singleton;

  /// Get a non-null instance of [SharedData]
  static SharedData get shared {
    if (_singleton == null) {
      Fimber.d('Please call `initSingleton` before using singleton');
    }
    return _singleton;
  }

  ///Method to init singleton, must be called before using singleton with only 1 time
  static Future<void> initSingleton({BuildContext context}) async {
    if (_singleton == null) {
      _singleton = SharedData(context: context);
    }
  }

  /// BuildContext - might be used when access context in localization
  BuildContext context;

  /// Initialize SharedData
  SharedData({this.context}) {}
}
