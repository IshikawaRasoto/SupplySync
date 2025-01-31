import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/constants/constants.dart';

class SecureDataStorage {
  static final SecureDataStorage _instance = SecureDataStorage._();
  SecureDataStorage._();
  factory SecureDataStorage() {
    return _instance;
  }

  final FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<void> writeData(SecureDataKeys key, String value) async {
    await storage.write(key: key.name, value: value);
  }

  Future<String?> readData(SecureDataKeys key) async {
    return await storage.read(key: key.name);
  }

  Future<void> deleteData(SecureDataKeys key) async {
    await storage.delete(key: key.name);
  }
}
