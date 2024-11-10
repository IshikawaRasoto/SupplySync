import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supplysync/models/user.dart';

import '../helper/ui_helper.dart';
import 'widgets/logo_and_help_widget.dart';

class ChangeProfileScreen extends StatefulWidget {
  const ChangeProfileScreen({super.key});
  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  late User _user;
  final _newEmailController = TextEditingController();

  final _atualPasswordController = TextEditingController();
  bool _obscureAtualPassword = true;
  final _newPasswordController = TextEditingController();
  bool _obscureNewPassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<User>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tight(const Size.fromHeight(200)),
              child: LogoAndHelpWidget(onReturn: () {
                context.pop();
              }),
            ),
            const SizedBox(height: 10),
            Text('Alterar perfil de ${_user.userName}',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6),
              padding: EdgeInsets.all(10.0),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Nome: ',
                      children: [
                        TextSpan(
                          text: _user.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      text: 'E-mail: ',
                      children: [
                        TextSpan(
                          text: _user.email,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: _newEmailController,
                    decoration: InputDecoration(
                      labelText: 'Novo E-mail',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () => setState(() =>
                            _obscureAtualPassword = !_obscureAtualPassword),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_newEmailController.text.isNotEmpty) {
                        _user.updateProfile(newEmail: _newEmailController.text);
                      }
                    },
                    child: const Text('Alterar E-mail'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _atualPasswordController,
                    obscureText: _obscureAtualPassword,
                    decoration: InputDecoration(
                      labelText: 'Senha Atual',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () => setState(() =>
                            _obscureAtualPassword = !_obscureAtualPassword),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      labelText: 'Nova Senha',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () => setState(
                            () => _obscureNewPassword = !_obscureNewPassword),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_atualPasswordController.text.isNotEmpty &&
                          _newPasswordController.text.isNotEmpty) {
                        _user.updateProfile(
                            oldPassword: _atualPasswordController.text,
                            newPassword: _newPasswordController.text);
                      }
                    },
                    child: const Text('Alterar Senha'),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      text: 'Permissões: ',
                      children: [
                        TextSpan(
                          text: _user.roles
                              .map((e) => UIHelper.capitalize(e.name))
                              .join(', '),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
