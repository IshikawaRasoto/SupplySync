import '../../../../core/domain/repositories/local_storage_repository.dart';
import '../../domain/repositories/auth_credentials_repository.dart';

class AuthCredentialsRepositoryImpl implements AuthCredentialsRepository {
  final LocalStorageRepository _secureStorage;

  AuthCredentialsRepositoryImpl(this._secureStorage);

  @override
  Future<String?> getSavedUsername() async {
    return await _secureStorage.readData('saved_username');
  }

  @override
  Future<void> setSavedUsername(String username) async {
    await _secureStorage.writeData('saved_username', username);
  }

  @override
  Future<String?> getSavedPassword() async {
    final result = await _secureStorage.readData('saved_password');
    return result;
  }

  @override
  Future<void> setSavedPassword(String password) async {
    await _secureStorage.writeData('saved_password', password);
  }

  @override
  Future<void> clearCredentials() async {
    await _secureStorage.deleteData('saved_username');
    await _secureStorage.deleteData('saved_password');
  }

  @override
  Future<bool> getSavePassword() async {
    return await _secureStorage.readBool('save_password');
  }

  @override
  Future<void> setSavePassword(bool save) async {
    await _secureStorage.writeBool('save_password', save);
  }
}
