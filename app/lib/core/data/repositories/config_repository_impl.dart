import '../../domain/repositories/config_repository.dart';
import '../../constants/constants.dart';
import '../../constants/api_constants.dart';
import '../../domain/repositories/local_storage_repository.dart';

class ConfigRepositoryImpl implements ConfigRepository {
  final LocalStorageRepository _nonSecureStorage;
  final LocalStorageRepository _secureStorage;

  ConfigRepositoryImpl({
    required LocalStorageRepository nonSecureStorage,
    required LocalStorageRepository secureStorage,
  })  : _nonSecureStorage = nonSecureStorage,
        _secureStorage = secureStorage;

  @override
  Future<String> getApiUrl() async {
    return await _nonSecureStorage.readData(DataKeys.apiUrl.name) ??
        ApiConstants.baseUrl;
  }

  @override
  Future<void> setApiUrl(String url) async {
    await _nonSecureStorage.writeData(DataKeys.apiUrl.name, url);
  }

  @override
  Future<String> getCompanyName() async {
    return await _nonSecureStorage.readData(DataKeys.companyName.name) ??
        MainConstants.companyName;
  }

  @override
  Future<void> setCompanyName(String name) async {
    await _nonSecureStorage.writeData(DataKeys.companyName.name, name);
  }
}
