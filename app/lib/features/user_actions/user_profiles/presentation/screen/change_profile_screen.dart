import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplysync/core/common/entities/user.dart';
import 'package:supplysync/core/utils/show_snackbar.dart';

import '../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../../core/common/widgets/logo_and_help_widget.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/utils/capitalize_utils.dart';
import '../../../../../core/utils/email_checker_utils.dart';
import '../../../../auth/presentation/blocs/auth_bloc.dart';
import '../blocs/user_actions_bloc.dart';
import '../blocs/user_request_bloc.dart';
import 'widgets/input_form_widget.dart';

class ChangeProfileScreen extends StatefulWidget {
  final String? targetUserName;
  const ChangeProfileScreen({super.key, this.targetUserName});
  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  late User _tagetUser;
  bool _isUserInitialized = false;

  final _newNameController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newConfirmPasswordController = TextEditingController();

  final _nameFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _passowrdFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.targetUserName != null) {
      context
          .read<UserRequestBloc>()
          .add(GetUserByUserName(widget.targetUserName!));
    } else {
      _tagetUser = (context.read<UserCubit>().state as UserLoggedIn).user;
      _isUserInitialized = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    _newNameController.dispose();
    _newEmailController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _newConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserRequestBloc, UserRequestState>(
        listener: (context, state) {
          if (state is UserRequestUserSuccess) {
            _tagetUser = state.user;
            _isUserInitialized = true;
          } else if (state is UserRequestFailure) {
            showSnackBar(context, message: state.message, isError: true);
          }
        },
        builder: (context, state) {
          if (!_isUserInitialized) {
            return const Center(child: CircularProgressIndicator());
          }
          return BlocListener<UserActionsBloc, UserActionsState>(
            listener: (context, state) {
              if (state is UserActionsSuccess) {
                showSnackBar(
                  context,
                  message: state.message,
                  isSucess: true,
                );
                if (widget.targetUserName != null) {
                  context
                      .read<UserRequestBloc>()
                      .add(GetUserByUserName(widget.targetUserName!));
                } else {
                  context.read<AuthBloc>().add(AuthGetCurrentUser());
                }
              } else if (state is UserActionsFailure) {
                showSnackBar(context, message: state.message, isError: true);
              }
            },
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints.tight(const Size.fromHeight(200)),
                  child: LogoAndHelpWidget(),
                ),
                const SizedBox(height: 10),
                Text('Alterar perfil de ${_tagetUser.userName}',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                      maxHeight: MediaQuery.of(context).size.height * 0.7),
                  padding: EdgeInsets.all(10.0),
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Nome: ',
                            children: [
                              TextSpan(
                                text: _tagetUser.userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: _nameFormKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Text.rich(
                                TextSpan(
                                  text: 'Nome: ',
                                  children: [
                                    TextSpan(
                                      text: _tagetUser.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              InputFormField(
                                controller: _newNameController,
                                hintText: 'Novo Nome',
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _nameFormKey.currentState!.validate()
                                      ? context.read<UserActionsBloc>().add(
                                            ChangeUserProfile(
                                              targetUserName:
                                                  _tagetUser.userName,
                                              newName: _newNameController.text
                                                  .trim(),
                                            ),
                                          )
                                      : null;
                                },
                                child: const Text('Alterar Nome'),
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: _emailFormKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Text.rich(
                                TextSpan(
                                  text: 'E-mail: ',
                                  children: [
                                    TextSpan(
                                      text: _tagetUser.email,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              InputFormField(
                                controller: _newEmailController,
                                hintText: 'Novo E-mail',
                                validator: (email) => !isValidEmail(email)
                                    ? 'E-mail inválido'
                                    : null,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _emailFormKey.currentState!.validate()
                                      ? context.read<UserActionsBloc>().add(
                                            ChangeUserProfile(
                                              targetUserName:
                                                  _tagetUser.userName,
                                              newEmail: _newEmailController.text
                                                  .trim(),
                                            ),
                                          )
                                      : null;
                                },
                                child: const Text('Alterar E-mail'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _passowrdFormKey,
                          child: Column(
                            children: [
                              InputFormField(
                                controller: _passwordController,
                                hintText: 'Senha Atual',
                                isObscureText: true,
                              ),
                              InputFormField(
                                controller: _newPasswordController,
                                hintText: 'Nova Senha',
                                isObscureText: true,
                                validator: (value) => value.length <
                                        AuthConstants.minPasswordLength
                                    ? 'A senha deve ter no mínimo ${AuthConstants.minPasswordLength} caracteres'
                                    : null,
                              ),
                              InputFormField(
                                controller: _newConfirmPasswordController,
                                hintText: 'Confirme a Nova Senha',
                                isObscureText: true,
                                validator: (text) =>
                                    text != _newPasswordController.text
                                        ? 'As senhas não coincidem'
                                        : null,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _passowrdFormKey.currentState!.validate()
                                      ? context.read<UserActionsBloc>().add(
                                            ChangeUserPassword(
                                              targetUserName:
                                                  _tagetUser.userName,
                                              newPassword:
                                                  _newPasswordController.text,
                                              oldPassword:
                                                  _passwordController.text,
                                            ),
                                          )
                                      : null;
                                },
                                child: const Text('Alterar Senha'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        PermisionsWidgets(user: _tagetUser),
                      ],
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

class PermisionsWidgets extends StatefulWidget {
  const PermisionsWidgets({
    super.key,
    required User user,
  }) : _user = user;

  final User _user;

  @override
  State<PermisionsWidgets> createState() => _PermisionsWidgetsState();
}

class _PermisionsWidgetsState extends State<PermisionsWidgets> {
  late List<UserRoles> _roles;
  late User _user;

  @override
  void initState() {
    super.initState();
    _roles = List.from(widget._user.roles);
    _user = (context.read<UserCubit>().state as UserLoggedIn).user;
  }

  @override
  Widget build(BuildContext context) {
    return _user.roles.contains(UserRoles.admin)
        ? Column(children: [
            const Text('Alterar Permissões',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...UserRoles.values.map((role) {
              return CheckboxListTile(
                title: Text(capitalize(role.toString().split('.').last)),
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
            }),
            ElevatedButton(
              onPressed: _roles.isNotEmpty ? _updateRoles : null,
              child: const Text('Alterar Permissões'),
            ),
          ])
        : Text.rich(
            TextSpan(
              text: 'Permissões: ',
              children: [
                TextSpan(
                  text: widget._user.roles
                      .map((e) => capitalize(e.name))
                      .join(', '),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
  }

  void _updateRoles() {
    context.read<UserActionsBloc>().add(
          UserChangeRolesRequest(
            targetUserName: widget._user.userName,
            newRoles: _roles,
          ),
        );
  }
}
