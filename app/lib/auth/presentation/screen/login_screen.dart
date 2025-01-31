import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/utils/show_snackbar.dart';
import '../../../core/common/widgets/logo_and_help_widget.dart';
import 'widget/settings_app_popup.dart';
import '../blocs/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  List<BiometricType> _availableBiometrics = [];

  // Form
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    _localAuth.isDeviceSupported().then((value) {
      if (value) {
        _localAuth.getAvailableBiometrics().then((value) {
          if (mounted) setState(() => _availableBiometrics = value);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login({bool biometric = false}) async {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _userNameController.text;
      final password = _passwordController.text;
      context
          .read<AuthBloc>()
          .add(AuthLogin(username: username, password: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const SettingsAppPopup(),
          );
        },
        child: const Icon(Icons.settings),
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(top: 16),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.go('/home');
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
            return Column(
              children: [
                LogoAndHelpWidget(),
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
                  padding: EdgeInsets.all(24),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
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
                                  icon: const Icon(Icons.remove_red_eye),
                                  onPressed: () => setState(
                                      () => _obscureText = !_obscureText),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _availableBiometrics
                                            .contains(BiometricType.face) ||
                                        _availableBiometrics
                                            .contains(BiometricType.iris)
                                    ? ElevatedButton(
                                        onPressed: () =>
                                            _login(biometric: true),
                                        child: const Text('Facial'),
                                      )
                                    : ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                        ),
                                        child: const Text('Facial'),
                                      ),
                                const SizedBox(width: 8),
                                _availableBiometrics
                                        .contains(BiometricType.fingerprint)
                                    ? ElevatedButton(
                                        onPressed: () =>
                                            _login(biometric: true),
                                        child: const Text('Biometria'),
                                      )
                                    : ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                        ),
                                        child: const Text('Biometria'),
                                      ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _login(),
                                  child: Text('Entrar'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Dialog();
                        },
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
            );
          },
        ),
      ),
    );
  }
}
