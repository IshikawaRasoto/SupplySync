import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'widgets/bar_widget.dart';

class WorkersScreen extends StatefulWidget {
  const WorkersScreen({super.key});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  late User _user;
  final List<Map<String, String>> workers = [
    {'id': '1', 'name': 'Gabriel'},
    {'id': '2', 'name': 'Alexei'},
    {'id': '3', 'name': 'Oda'},
    {'id': '4', 'name': 'Rafael'},
    {'id': '5', 'name': 'Pamonha'},
    {'id': '6', 'name': 'Ayumi'},
    {'id': '7', 'name': 'Julia'},
  ];

  @override
  void initState() {
    _user = Provider.of<User>(context, listen: false);
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: workers.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final worker = workers[index];
                    return ListTile(
                      title: Text(worker['name']!),
                      trailing: TextButton(
                        onPressed: () => context.go(
                          '/home/changeprofile',
                          extra: worker['id'], 
                        ),
												child: const Text("Editar"),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => context.go('/home/workers/registeruser'),
                child: const Text('Adicionar Novo Trabalhador'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

