import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supplysync/constants/constants.dart';

import '../api/api_service.dart';
import '../helper/ui_helper.dart';
import '../models/user.dart';
import 'widgets/logo_and_help_widget.dart';
import 'widgets/settings_app_popup.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});
  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  User? newUser;
  final ApiService apiService = ApiService();

  // Form
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final List<UserRoles> _roles = [UserRoles.user];

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerNewUser() async {
    if (_formKey.currentState!.validate()) {
      final newUser = User(
        email: _emailController.text,
        password: _passwordController.text,
        userName: _userNameController.text,
        fullName: _fullNameController.text,
      );
      if (await newUser.register(roles: _roles)) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Sucesso'),
              content: const Text('Usuário registrado com sucesso'),
              actions: [
                TextButton(
                  onPressed: () => context.goNamed('/'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        if (mounted) context.goNamed('/');
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Erro'),
              content: const Text('Erro ao registrar usuário'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
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
        child: Column(
          children: [
            Expanded(child: LogoAndHelpWidget()),
            Expanded(
              flex: 3,
              child: Container(
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
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text('Dados',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Campo necessário'
                              : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'E-mail',
                            hintText: 'Digite o e-mail',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
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
                            hintText: 'Digite a senha',
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
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _fullNameController,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Campo necessário'
                              : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Nome Completo',
                            hintText: 'Digite o nome completo',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text('Permissões',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        CheckboxListTile(
                          title: Text(UIHelper.capitalize(
                              UserRoles.user.toString().split('.').last)),
                          value: true,
                          onChanged: (value) {},
                        ),
                        for (var role in UserRoles.values)
                          if (role != UserRoles.none && role != UserRoles.user)
                            CheckboxListTile(
                              title: Text(UIHelper.capitalize(
                                  role.toString().split('.').last)),
                              value: _roles.contains(role),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    _roles.add(role);
                                  } else {
                                    _roles.remove(role);
                                  }
                                });
                              },
                            ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => _registerNewUser(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text('Registrar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
