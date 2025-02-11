import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../../core/common/entities/user.dart';
import '../../../../../core/theme/theme.dart';
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
    super.initState();
    _user = (context.read<UserCubit>().state as UserLoggedIn).user;
    _loadWorkers();
  }

  void _loadWorkers() {
    context.read<UserRequestBloc>().add(GetAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabalhadores'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/home/registeruser'),
        backgroundColor: AppColors.deepPurple,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.person_add),
        label: const Text('Novo Trabalhador'),
      ),
      body: BlocConsumer<UserRequestBloc, UserRequestState>(
        listener: (context, state) {
          if (state is UserRequestAllUsersSuccess) {
            setState(() {
              _workers = state.users;
            });
          }
        },
        builder: (context, state) {
          if (state is UserRequestLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadWorkers();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _workers.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum trabalhador encontrado',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _workers.length,
                      itemBuilder: (context, index) {
                        final worker = _workers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            worker.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            worker.userName,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => _user.userName ==
                                              worker.userName
                                          ? context.go('/home/changeprofile')
                                          : context.go(
                                              '/home/changeprofile?targetUser=${worker.userName}',
                                            ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.deepPurple,
                                        foregroundColor: AppColors.white,
                                      ),
                                      icon: const Icon(Icons.edit,
                                          color: AppColors.white),
                                      label: const Text('Editar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
