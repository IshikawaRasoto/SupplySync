abstract interface class LocalStorageRepository {
  Future<void> writeData(String key, String value);
  Future<String?> readData(String key);
  Future<void> writeBool(String key, bool value);
  Future<bool> readBool(String key);
  Future<void> deleteData(String key);
  Future<void> clearData();
}
