import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supplysync/core/utils/show_snackbar.dart';

import '../../../../../core/common/cubit/settings/settings_cubit.dart';

class SettingsAppPopup extends StatefulWidget {
  const SettingsAppPopup({
    super.key,
  });

  @override
  State<SettingsAppPopup> createState() => _SettingsAppPopupState();
}

class _SettingsAppPopupState extends State<SettingsAppPopup> {
  late SettingsCubit settingsCubit;
  final _serverUrlController = TextEditingController();
  final _nameCompanyController = TextEditingController();

  @override
  void initState() {
    settingsCubit = context.read<SettingsCubit>()..loadSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 56,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
          title: const Text('Configurações',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              )),
          actions: [
            Container(
              margin: EdgeInsets.all(12),
              child: TextButton(
                onPressed: () {
                  settingsCubit.saveSettings(
                    companyName: _nameCompanyController.text,
                    apiUrl: _serverUrlController.text,
                  );
                  context.pop();
                },
                child: const Text(
                  'SALVAR',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
        body: BlocConsumer<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if (state is SettingsSaved) {
              showSnackBar(
                context,
                message: 'Configurações salvas com sucesso',
              );
            } else if (state is SettingsLoaded) {
              _serverUrlController.text = state.apiUrl;
              _nameCompanyController.text = state.companyName ?? 'Supply Sync';
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCompanyController,
                    cursorColor: Colors.black,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo necessário'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Nome da Empresa',
                      labelStyle:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      hintText: 'Digite o nome da empresa',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _serverUrlController,
                    cursorColor: Colors.black,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo necessário'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'URL do Servidor',
                      hintText: 'Digite a URL do servidor',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
