import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/constants.dart';

class DataStorage {
  static final DataStorage _instance = DataStorage._();
  DataStorage._();
  factory DataStorage() {
    return _instance;
  }

  late SharedPreferences _sharedPreferences;
  bool _initialization = false;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _initialization = true;
  }

  Future<void> writeData(DataKeys key, String value) async {
    if (!_initialization) await init();
    await _sharedPreferences.setString(key.name, value);
  }

  Future<String?> readData(DataKeys key) async {
    if (!_initialization) await init();
    return _sharedPreferences.getString(key.name);
  }

  Future<void> writeBool(DataKeys key, bool value) async {
    if (!_initialization) await init();
    await _sharedPreferences.setBool(key.name, value);
  }

  Future<bool?> readBool(DataKeys key) async {
    if (!_initialization) await init();
    return _sharedPreferences.getBool(key.name);
  }

  Future<void> deleteData(DataKeys key) async {
    if (!_initialization) await init();
    await _sharedPreferences.remove(key.name);
  }

  Future<void> clearData() async {
    if (!_initialization) await init();
    await _sharedPreferences.clear();
  }
}
