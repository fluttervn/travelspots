import 'dart:convert';

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

  Future<List> getAll() async {
    SharedPreferences prefs = await _getPref();
    List values = prefs.get(worksheetsKey);
    return values;
  }

  Future setAll(dynamic input) async {
    SharedPreferences prefs = await _getPref();
    List<String> stringList =
        (jsonDecode(input) as List<dynamic>).cast<String>();
    print('value: $stringList');
//    List values = prefs.set
  }
}
