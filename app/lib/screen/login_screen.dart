import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:supplysync/repository/data_storage.dart';
import 'package:supplysync/repository/secure_data_storage.dart';

import '../api/api_service.dart';
import '../constants/constants.dart';
import '../helper/ui_helper.dart';
import '../models/user.dart';
import 'widgets/logo_and_help_widget.dart';
import 'widgets/settings_app_popup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late User _user;
  final ApiService apiService = ApiService();
  final SecureDataStorage _secureDataStorage = SecureDataStorage();
  final DataStorage _dataStorage = DataStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  String? _savedUserName;
  String? _savedPassword;
  List<BiometricType> _availableBiometrics = [];

  // Form
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    _user = Provider.of<User>(context, listen: false);
    _localAuth.isDeviceSupported().then((value) {
      if (value) {
        _localAuth.getAvailableBiometrics().then((value) {
          if (mounted) setState(() => _availableBiometrics = value);
        });
      }
    });
    _secureDataStorage.readData(SecureDataKeys.userName).then((value) {
      _savedUserName = value;
      if (value != null && mounted) {
        setState(() {
          _userNameController.text = value;
        });
      }
    });
    _secureDataStorage
        .readData(SecureDataKeys.password)
        .then((value) => _savedPassword = value);
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login({bool biometric = false}) async {
    if (await _user.fakeLogin(_userNameController.text)) {
      if (mounted) context.go('/home');
    }
    try {
      String username = '';
      String password = '';
      if (biometric &&
          _savedUserName != null &&
          _savedPassword != null &&
          await _localAuth.authenticate(
            localizedReason: 'Faça a autenticação facial para continuar',
            options: const AuthenticationOptions(
              biometricOnly: true,
            ),
          )) {
        username = _savedUserName!;
        password = _savedPassword!;
      } else if (_formKey.currentState!.validate()) {
        username = _userNameController.text;
        password = _passwordController.text;
      }
      if (await _user.login(username, password)) {
        await _secureDataStorage.writeData(SecureDataKeys.userName, username);
        if (await _dataStorage.readBool(DataKeys.savePassword) ?? false) {
          await _secureDataStorage.writeData(SecureDataKeys.password, password);
        }
        if (mounted) context.go('/home');
      }
    } catch (e) {
      if (mounted) UIHelper.showErrorSnackBar(context, e.toString());
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
        child: Column(
          children: [
            LogoAndHelpWidget(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
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
                          validator: (value) => value == null || value.isEmpty
                              ? 'Campo necessário'
                              : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          validator: (value) => value == null || value.isEmpty
                              ? 'Campo necessário'
                              : null,
                          obscureText: _obscureText,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Senha',
                            hintText: 'Digite sua senha',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () =>
                                  setState(() => _obscureText = !_obscureText),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _availableBiometrics.contains(BiometricType.face) ||
                                    _availableBiometrics
                                        .contains(BiometricType.iris)
                                ? ElevatedButton(
                                    onPressed: () => _login(biometric: true),
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
                                    onPressed: () => _login(biometric: true),
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
        ),
      ),
    );
  }
}
