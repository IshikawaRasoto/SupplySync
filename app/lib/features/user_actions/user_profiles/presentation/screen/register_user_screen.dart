import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supplysync/core/constants/constants.dart';
import 'package:supplysync/core/utils/email_checker_utils.dart';
import 'package:supplysync/core/utils/show_snackbar.dart';

import '../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../../core/common/entities/user.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/capitalize_utils.dart';
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
      appBar: AppBar(
        title: const Text('Registrar Usuário'),
        centerTitle: true,
      ),
      body: BlocConsumer<UserActionsBloc, UserActionsState>(
        listener: (context, state) {
          if (state is UserActionsSuccess) {
            showSnackBar(
              context,
              message: 'Usuário registrado com sucesso',
              isSucess: true,
            );
            context.pop();
          } else if (state is UserActionsFailure) {
            showSnackBar(
              context,
              message: state.message,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: getColorWithOpacity(AppColors.grey, 0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Dados do Usuário',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
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
                            validator: (value) =>
                                !isValidEmail(value) ? 'E-mail inválido' : null,
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
                          const SizedBox(height: 20),
                          const Text(
                            'Permissões',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...UserRoles.values.map((role) {
                            return CheckboxListTile(
                              title: Text(
                                capitalize(role.toString().split('.').last),
                              ),
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
                            );
                          }).toList(),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _formKey.currentState!.validate()
                                ? context.read<UserActionsBloc>().add(
                                      RegisterNewUser(
                                        jwtToken: _user.jwtToken,
                                        userName:
                                            _userNameController.text.trim(),
                                        name: _fullNameController.text.trim(),
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                        roles: _roles,
                                      ),
                                    )
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.green,
                              minimumSize: const Size(double.infinity, 45),
                            ),
                            child: const Text(
                              'Registrar',
                              style: TextStyle(
                                color: AppColors.buttonText,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
