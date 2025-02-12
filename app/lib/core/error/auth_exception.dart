class AuthException implements Exception {
  final bool isLoggedIn;
  final String message;
  AuthException({this.isLoggedIn = false})
      : message =
            isLoggedIn ? 'Login Realizado com Sucesso' : 'Usuário não Logado';
}
