import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl implements LocalStorageRepository {
  factory LocalStorageRepositoryImpl() => _instance;
  LocalStorageRepositoryImpl._() {
    init();
  }
  static final LocalStorageRepositoryImpl _instance =
      LocalStorageRepositoryImpl._();

  bool _initialization = false;
  late SharedPreferences _sharedPreferences;

  @override
  Future<void> clearData() async {
    if (!_initialization) await init();
    await _sharedPreferences.clear();
  }

  @override
  Future<void> deleteData(String key) async {
    if (!_initialization) await init();
    await _sharedPreferences.remove(key);
  }

  @override
  Future<bool> readBool(String key) async {
    if (!_initialization) await init();
    return _sharedPreferences.getBool(key) ?? false;
  }

  @override
  Future<String?> readData(String key) async {
    if (!_initialization) await init();
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    if (!_initialization) await init();
    await _sharedPreferences.setBool(key, value);
  }

  @override
  Future<void> writeData(String key, String value) async {
    if (!_initialization) await init();
    await _sharedPreferences.setString(key, value);
  }

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _initialization = true;
  }
}
