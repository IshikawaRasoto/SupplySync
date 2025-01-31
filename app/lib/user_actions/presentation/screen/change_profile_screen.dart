import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplysync/core/common/entities/user.dart';
import 'package:supplysync/core/utils/show_snackbar.dart';
import 'package:supplysync/user_actions/presentation/blocs/user_actions_bloc.dart';
import 'package:supplysync/user_actions/presentation/screen/widgets/change_profile_input_widget.dart';

import '../../../core/common/cubit/user/user_cubit.dart';
import '../../../core/common/widgets/logo_and_help_widget.dart';
import '../../../core/utils/capitalize_utils.dart';
import '../../../core/utils/email_checker_utils.dart';
import '../blocs/user_request_bloc.dart';

class ChangeProfileScreen extends StatefulWidget {
  final String? targetUserName;
  const ChangeProfileScreen({super.key, this.targetUserName});
  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  late User _user;
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
      _user = (context.read<UserCubit>().state as UserLoggedIn).user;
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
    return BlocConsumer<UserRequestBloc, UserRequestState>(
      listener: (context, state) {
        if (state is UserRequestUserSuccess) {
          _user = state.user;
          _isUserInitialized = true;
        } else if (state is UserRequestFailure) {
          showSnackBar(context, message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        if (!_isUserInitialized) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          body: BlocListener<UserActionsBloc, UserActionsState>(
            listener: (context, state) {
              if (state is UserActionsSuccess) {
                showSnackBar(context, message: state.message);
              } else if (state is UserFailure) {
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
                Text('Alterar perfil de ${_user.userName}',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
                        color: Colors.grey
                            .withAlpha(Color.getAlphaFromOpacity(0.5)),
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                                    text: _user.email,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            ChangeProfileInputWidget(
                              controller: _newNameController,
                              hintText: 'Novo Nome',
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _nameFormKey.currentState!.validate()
                                    ? context.read<UserActionsBloc>().add(
                                          ChangeUserProfile(
                                            targetUserName: _user.userName,
                                            newEmail:
                                                _newNameController.text.trim(),
                                          ),
                                        )
                                    : null;
                              },
                              child: const Text('Alterar E-mail'),
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
                                    text: _user.email,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            ChangeProfileInputWidget(
                              controller: _newEmailController,
                              hintText: 'Novo E-mail',
                              validator: (email) => isValidEmail(email)
                                  ? 'E-mail inválido'
                                  : null,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _emailFormKey.currentState!.validate()
                                    ? context.read<UserActionsBloc>().add(
                                          ChangeUserProfile(
                                            targetUserName: _user.userName,
                                            newEmail:
                                                _newEmailController.text.trim(),
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
                            ChangeProfileInputWidget(
                              controller: _passwordController,
                              hintText: 'Senha Atual',
                              isObscureText: true,
                            ),
                            ChangeProfileInputWidget(
                              controller: _newPasswordController,
                              hintText: 'Nova Senha',
                              isObscureText: true,
                            ),
                            ChangeProfileInputWidget(
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
                                            targetUserName: _user.userName,
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
                      Text.rich(
                        TextSpan(
                          text: 'Permissões: ',
                          children: [
                            TextSpan(
                              text: _user.roles
                                  .map((e) => capitalize(e.name))
                                  .join(', '),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
      },
    );
  }
}
