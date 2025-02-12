abstract interface class ConfigRepository {
  Future<String> getApiUrl();
  Future<void> setApiUrl(String url);
  Future<String> getCompanyName();
  Future<void> setCompanyName(String name);
}
