import '../../../../core/domain/repositories/local_storage_repository.dart';

abstract class LocalStorageDataSource {
  Future<bool> readBool(String key);
  Future<void> writeBool(String key, bool value);
}

class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  final LocalStorageRepository _localStorageRepository;

  LocalStorageDataSourceImpl(this._localStorageRepository);

  @override
  Future<bool> readBool(String key) async {
    return await _localStorageRepository.readBool(key);
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    await _localStorageRepository.writeBool(key, value);
  }
}
