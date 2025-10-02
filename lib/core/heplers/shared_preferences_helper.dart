import 'package:shared_preferences/shared_preferences.dart';

import '../networking/exceptions.dart';

class SharedPreferencesHelper {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesHelper({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  dynamic getData({required String key}) {
    return _sharedPreferences.get(key);
  }

  Future<void> saveData({required String key, required dynamic value}) async {
    try {
      if (value is String) {
        await _sharedPreferences.setString(key, value);
      } else if (value is int) {
        await _sharedPreferences.setInt(key, value);
      } else if (value is bool) {
        await _sharedPreferences.setBool(key, value);
      } else if (value is double) {
        await _sharedPreferences.setDouble(key, value);
      } else {
        await _sharedPreferences.setString(key, value.toString());
      }
    } catch (e) {
      throw AppException("Error in saving data");
    }
  }

  Future<bool> removeData(String key) async {
    try {
      return await _sharedPreferences.remove(key);
    } catch (e) {
      throw AppException("Error in removing data");
    }
  }

  Future<bool> clearData() async {
    try {
      return await _sharedPreferences.clear();
    } catch (e) {
      throw AppException("Error in clearing data");
    }
  }

  String? get token => getData(key: 'token');
  setToken(String? token) async {
    await saveData(key: 'token', value: token as String);
  }

  removeToken() async {
    await removeData('token');
  }
}
