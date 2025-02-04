import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../core/common/entities/user.dart';
import '../blocs/user_request_bloc.dart';

class WorkersScreen extends StatefulWidget {
  const WorkersScreen({super.key});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  List<User> _workers = [];
  late User _user;

  @override
  void initState() {
    (context.read<UserRequestBloc>().add(GetAllUsers()));
    _user = (context.read<UserCubit>().state as UserLoggedIn).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trabalhadores"),
      ),
      body: SafeArea(
          minimum: const EdgeInsets.only(top: 10),
          child: BlocConsumer<UserRequestBloc, UserRequestState>(
            listener: (context, state) {
              if (state is UserRequestAllUsersSuccess) {
                _workers = state.users;
              }
            },
            builder: (context, state) {
              if (state is UserRequestLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: _workers.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final worker = _workers[index];
                          return ListTile(
                            title: Text(worker.userName),
                            subtitle: Text(worker.name),
                            trailing: TextButton(
                              onPressed: () => _user.userName == worker.userName
                                  ? context.go('/home/changeprofile')
                                  : context.go(
                                      '/home/changeprofile?targetUser=${worker.userName}',
                                    ),
                              child: const Text("Editar"),
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.go('/home/registeruser'),
                      child: const Text('Adicionar Novo Trabalhador'),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
