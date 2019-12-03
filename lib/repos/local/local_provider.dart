import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

final String worksheetsKey = 'worksheets';
final String firstLaunchTimeKey = 'firstLaunchTime';

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

  Future<Map<String, int>> getAll() async {
    SharedPreferences prefs = await _getPref();
    String values = prefs.get(worksheetsKey);
    if (values == null || values.isEmpty) return null;
    Map<String, int> map = Map.castFrom(json.decode(values));
    return map;
  }

  Future setAll(Map<String, int> input) async {
    SharedPreferences prefs = await _getPref();
    String textMapIdTime = jsonEncode(input);
    print('Pref setAll: input: $input');
    print('Pref setAll: textMapIdTime: $textMapIdTime');
    await prefs.setString(worksheetsKey, textMapIdTime);
  }

  Future<bool> isFirstTimeLauncher() async {
    SharedPreferences prefs = await _getPref();
    bool isFirstTime = prefs.getBool(firstLaunchTimeKey);
    return isFirstTime == true;
  }

  Future setFirstTimeLauncher(bool isFistTime) async {
    SharedPreferences prefs = await _getPref();
    await prefs.setBool(firstLaunchTimeKey, isFistTime);
  }
}
