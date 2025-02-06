import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:supplysync/features/auth/presentation/cubit/auth_credentials_cubit.dart';

import '../../../../core/utils/show_snackbar.dart';
import '../../../../core/common/widgets/logo_and_help_widget.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
import 'widget/settings_app_popup.dart';
import '../blocs/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with RouteAware {
  final Logger _logger = Logger();

  late AuthCredentialsCubit authCredentialsCubit;
  late AuthBloc authBloc;

  final List<BiometricType> _availableBiometrics = [];
  bool _isBiometricsAvailable = false;

  final _formKey = GlobalKey<FormState>();
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _obscureText = true;
  final _passwordController = TextEditingController();
  String _savedUsername = '';
  String _savedPassword = '';
  bool _savePassword = false;
  final _userNameController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authCredentialsCubit = context.read<AuthCredentialsCubit>();
    authCredentialsCubit.loadCredentials();
    GoRouter.of(context).routerDelegate.addListener(_onRouteChange);
  }

  @override
  void dispose() {
    GoRouter.of(context).routerDelegate.removeListener(_onRouteChange);
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRouteChange() {
    if (mounted && ModalRoute.of(context)?.isCurrent == true) {
      authCredentialsCubit.loadCredentials();
    }
  }

  @override
  void initState() {
    super.initState();
    authBloc = context.read<AuthBloc>();
    _checkBiometricAvailability();
    _getFirebaseToken();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      if (isDeviceSupported) {
        final biometrics = await _localAuth.getAvailableBiometrics();
        if (mounted) {
          setState(() {
            _availableBiometrics.addAll(biometrics);
            _isBiometricsAvailable = biometrics.isNotEmpty;
          });
        }
      }
      _logger.d(
          'Biometrics is ${isDeviceSupported ? 'supported\nBiometrics available: $_availableBiometrics' : 'NOT supported'}');
    } catch (e) {
      _logger.e('Error checking biometric availability: $e');
      if (mounted) {
        setState(() => _isBiometricsAvailable = false);
      }
    }
  }

  void _getFirebaseToken() async {
    final firebaseToken =
        await context.read<NotificationCubit>().getFirebaseToken();
    _logger.d('Firebase Token: $firebaseToken');
  }

  Future<void> _authenticateWithBiometrics() async {
    if (!_isBiometricsAvailable ||
        _savedPassword.isEmpty ||
        _savedUsername.isEmpty) {
      return;
    }
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Autentique-se para acessar o aplicativo',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (mounted && isAuthenticated) {
        authBloc
            .add(AuthLogin(username: _savedUsername, password: _savedPassword));
      }
    } catch (e) {
      _logger.e('Biometric authentication error: $e');
      if (mounted) {
        showSnackBar(
          context,
          message: 'Erro na autenticação biométrica. Tente novamente.',
          isError: true,
        );
      }
    }
  }

  Future<void> _loginWithCredentials() async {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _userNameController.text;
      final password = _passwordController.text;
      authBloc.add(AuthLogin(username: username, password: password));
    }
  }

  Widget _buildAuthButton({
    required String text,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  bool get _canUseBiometrics =>
      _isBiometricsAvailable &&
      _savedPassword.isNotEmpty &&
      _savedUsername.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Configurações',
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const SettingsAppPopup(),
          );
        },
        child: const Icon(Icons.settings),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 36),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              authCredentialsCubit.saveCredentials(
                username: _userNameController.text,
                password: _passwordController.text,
                savePassword: _savePassword,
              );
              context.goNamed('home');
            } else if (state is AuthFailure) {
              showSnackBar(
                context,
                message: state.message,
                isError: true,
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return BlocListener<AuthCredentialsCubit, AuthCredentialsState>(
              listener: (context, state) {
                if (state is AuthCredentialsLoaded) {
                  setState(() {
                    _userNameController.text = state.username ?? '';
                    _savedPassword = state.password ?? '';
                    _savePassword = state.savePassword ?? false;
                  });
                }
              },
              child: Column(
                children: [
                  const LogoAndHelpWidget(back: false),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withAlpha(Color.getAlphaFromOpacity(0.5)),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 24),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _userNameController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Campo necessário'
                                        : null,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: 'Usuário',
                                  hintText: 'Digite seu usuário',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _passwordController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Campo necessário'
                                        : null,
                                obscureText: _obscureText,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: 'Senha',
                                  hintText: 'Digite sua senha',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () => setState(
                                        () => _obscureText = !_obscureText),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Salvar senha'),
                                  Checkbox(
                                    value: _savePassword,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _savePassword = value ?? false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              if (_availableBiometrics.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                _buildAuthButton(
                                  text: 'Autenticação Biométrica',
                                  icon: _availableBiometrics
                                          .contains(BiometricType.face)
                                      ? Icons.face
                                      : Icons.fingerprint,
                                  onPressed: _canUseBiometrics
                                      ? _authenticateWithBiometrics
                                      : null,
                                ),
                                const SizedBox(height: 8),
                              ],
                              _buildAuthButton(
                                text: 'Entrar com Senha',
                                icon: Icons.login,
                                onPressed: _loginWithCredentials,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => Dialog(),
                          child: const Text(
                            'Esqueci minha senha',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
