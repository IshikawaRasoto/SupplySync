import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supplysync/core/constants/constants.dart';
import 'package:supplysync/core/utils/email_checker_utils.dart';

import '../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/common/widgets/logo_and_help_widget.dart';
import '../../../auth/presentation/screen/widget/settings_app_popup.dart';
import '../../../../core/utils/capitalize_utils.dart';
import '../blocs/user_actions_bloc.dart';
import 'widgets/input_form_widget.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});
  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  late User _user;
  // Form
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final List<UserRoles> _roles = [];

  @override
  void initState() {
    _user = (context.read<UserCubit>().state as UserLoggedIn).user;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
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
        child: BlocConsumer<UserActionsBloc, UserActionsState>(
          listener: (context, state) {
            if (state is UserActionsSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop();
            } else if (state is UserFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
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
                          color: Colors.grey
                              .withAlpha(Color.getAlphaFromOpacity(0.5)),
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
                            InputFormField(
                              controller: _userNameController,
                              hintText: 'Username',
                            ),
                            const SizedBox(height: 12),
                            InputFormField(
                              controller: _fullNameController,
                              hintText: 'Nome Completo',
                            ),
                            const SizedBox(height: 12),
                            InputFormField(
                              controller: _emailController,
                              hintText: 'E-mail',
                              validator: (value) => !isValidEmail(value)
                                  ? 'E-mail inválido'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            InputFormField(
                              controller: _passwordController,
                              hintText: 'Senha',
                              isObscureText: true,
                              validator: (value) => value.length <
                                      AuthConstants.minPasswordLength
                                  ? 'Senha deve ter no mínimo ${AuthConstants.minPasswordLength} caracteres'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            const Text('Permissões',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            for (var role in UserRoles.values)
                              CheckboxListTile(
                                title: Text(capitalize(
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
                              onPressed: () => _formKey.currentState!.validate()
                                  ? context.read<UserActionsBloc>().add(
                                        RegisterNewUser(
                                          jwtToken: _user.jwtToken,
                                          userName: _userNameController.text,
                                          name: _fullNameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          roles: _roles,
                                        ),
                                      )
                                  : null,
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
            );
          },
        ),
      ),
    );
  }
}
