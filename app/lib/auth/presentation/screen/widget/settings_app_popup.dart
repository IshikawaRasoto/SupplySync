import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supplysync/repository/data_storage.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/constants.dart';

class SettingsAppPopup extends StatefulWidget {
  const SettingsAppPopup({
    super.key,
  });

  @override
  State<SettingsAppPopup> createState() => _SettingsAppPopupState();
}

class _SettingsAppPopupState extends State<SettingsAppPopup> {
  final DataStorage _dataStorage = DataStorage();

  final _serverUrlController = TextEditingController();
  final _nameCompanyController = TextEditingController();
  bool _savedPassword = false;

  void _saveChanges() {
    _dataStorage.writeData(DataKeys.apiUrl, _serverUrlController.text);
    _dataStorage.writeData(DataKeys.companyName, _nameCompanyController.text);
    _dataStorage.writeBool(DataKeys.savePassword, _savedPassword);
  }

  @override
  void initState() {
    _dataStorage.readData(DataKeys.apiUrl).then((value) {
      _serverUrlController.text = value ?? ApiConstants.baseUrl;
      if (mounted) setState(() {});
    });
    _dataStorage.readData(DataKeys.companyName).then((value) {
      _nameCompanyController.text = value ?? MainConstants.companyName;
      if (mounted) setState(() {});
    });
    _dataStorage.readBool(DataKeys.savePassword).then((value) {
      _savedPassword = value ?? false;
      if (mounted) setState(() {});
    });
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
                  _saveChanges();
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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: _nameCompanyController,
                cursorColor: Colors.black,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo necessário' : null,
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
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo necessário' : null,
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Salvar senha',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: _savedPassword,
                    onChanged: (value) {
                      setState(() {
                        _savedPassword = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
