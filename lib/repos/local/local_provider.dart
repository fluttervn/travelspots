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
    String valueStr = prefs.get(worksheetsKey);
    List values = jsonDecode(valueStr);
    print('decode: $values');
    return values;
  }

  Future setAll(List input) async {
    SharedPreferences prefs = await _getPref();
    String encodeStr = jsonEncode(input);
    print('encode: $encodeStr');

    prefs.setString(worksheetsKey, encodeStr);
  }
}
