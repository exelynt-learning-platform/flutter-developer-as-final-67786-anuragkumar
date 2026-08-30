import 'package:shared_preferences/shared_preferences.dart';

abstract interface class PreferencesStorage {
  Future<String?> getString(String key);

  Future<void> setString(String key, String value);

  Future<bool?> getBool(String key);

  Future<void> setBool(String key, bool value);

  Future<void> remove(String key);
}


class PreferencesStorageImpl implements PreferencesStorage {
  PreferencesStorageImpl(this._preferences);

  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> getString(String key) {
    return _preferences.getString(key);
  }

  @override
  Future<void> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  @override
  Future<bool?> getBool(String key) {
    return _preferences.getBool(key);
  }

  @override
  Future<void> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  @override
  Future<void> remove(String key) {
    return _preferences.remove(key);
  }
}
