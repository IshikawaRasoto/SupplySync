abstract interface class AuthCredentialsRepository {
  Future<String?> getSavedUsername();
  Future<void> setSavedUsername(String username);
  Future<String?> getSavedPassword();
  Future<void> setSavedPassword(String password);
  Future<bool> getSavePassword();
  Future<void> setSavePassword(bool save);
  Future<void> clearCredentials();
}
