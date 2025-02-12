import 'dart:async';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/screen/login_dialog.dart';
import 'navigation_service.dart';

abstract class AuthInterceptorService {
  Future<bool> handleUnauthorized();
}

class AuthInterceptorServiceImpl implements AuthInterceptorService {
  final _authCompleter = Completer<bool>();
  bool _isShowingDialog = false;

  @override
  Future<bool> handleUnauthorized() async {
    final context = NavigationService.currentContext;
    if (context == null) return false;

    if (!_isShowingDialog) {
      _isShowingDialog = true;
      _showLoginDialog(context);
    }
    return _authCompleter.future;
  }

  void _showLoginDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoginDialog(),
    );

    _isShowingDialog = false;
    if (!_authCompleter.isCompleted) {
      _authCompleter.complete(result ?? false);
    }
  }
}
