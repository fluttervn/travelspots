import 'package:shared_preferences/shared_preferences.dart';

final String worksheetsKey = 'worksheets';

/// A class help handle local data
class LocalProvider {
  /// Shared preference
  SharedPreferences _pref;

  Future<SharedPreferences> _getPref() async {
    if (_pref == null) {
      _pref = await SharedPreferences.getInstance();
    }
    return _pref;
  }
}
