import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/repositories/local_storage_repository.dart';

class SecureStorageRepositoryImpl implements LocalStorageRepository {
  static final SecureStorageRepositoryImpl _instance =
      SecureStorageRepositoryImpl._();
  SecureStorageRepositoryImpl._();
  factory SecureStorageRepositoryImpl() => _instance;

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  Future<void> writeData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> readData(String key) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> clearData() async {
    await _storage.deleteAll();
  }

  @override
  Future<bool> readBool(String key) async {
    return (await _storage.read(key: key)) == 'true';
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    await _storage.write(key: key, value: value.toString());
  }
}
