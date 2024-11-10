import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../api/api_service.dart';
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

  // Form
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  Future<void> _login() async {
    if (await _user.fakeLogin()) {
      if (mounted) context.go('/home');
    }
    try {
      if (_formKey.currentState!.validate()) {
        if (context.mounted) {
          UIHelper.showSnackBar(context, 'Realizando login...');
        }
        // if (await _user.login(
        //     _userNameController.text, _passwordController.text)) {
        //   if (mounted) context.go('/home');
        // }
      }
    } catch (e) {
      if (mounted) UIHelper.showErrorSnackBar(context, e.toString());
    }
  }

  @override
  void initState() {
    _user = Provider.of<User>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            Expanded(
              flex: 3,
              child: LogoAndHelpWidget(),
            ),
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
                            ElevatedButton(
                              onPressed: () => _login(),
                              child: const Text('Facial'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _login(),
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
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
