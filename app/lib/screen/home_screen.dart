import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:supplysync/helper/ui_helper.dart';

import '../constants/constants.dart';
import '../helper/permission_helper.dart';
import '../models/user.dart';
import 'widgets/logo_and_help_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _user;

  @override
  void initState() {
    _user = Provider.of<User>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            LogoAndHelpWidget(logout: true),
            const SizedBox(height: 10),
            Text('Bem-vindo ${_user.userName}',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  Size size = getValueForScreenType<Size>(
                    context: context,
                    mobile: const Size(100, 100),
                    tablet: const Size(160, 160),
                  );
                  final count = constraints.maxWidth ~/ size.width;
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.count(
                      crossAxisCount: count,
                      crossAxisSpacing: 8,
                      childAspectRatio: size.height / size.width,
                      mainAxisSpacing: 30,
                      shrinkWrap: true,
                      children: [
                        if (PermissionHelper.checkUserRolePermission(
                            _user, UserPermissions.loadingDock))
                          UIHelper.buttonIconAndTextWidget(
                            context,
                            Icons.local_shipping,
                            'Carregamento',
                            () {
                              context.go('/home/docks');
                            },
                          ),
                        if (PermissionHelper.checkUserRolePermission(
                            _user, UserPermissions.fetchWarehouses))
                          UIHelper.buttonIconAndTextWidget(
                            context,
                            Icons.warehouse,
                            'Armazéns',
                            () {
                              context.go('/home/warehouses');
                            },
                          ),
                        if (PermissionHelper.checkUserRolePermission(
                            _user, UserPermissions.drones))
                          UIHelper.buttonIconAndTextWidget(
                            context,
                            Icons.toys,
                            'Drones',
                            () {
                              context.go('/home/drones');
                            },
                          ),
                        if (PermissionHelper.checkUserRolePermission(
                            _user, UserPermissions.fetchRecords))
                          UIHelper.buttonIconAndTextWidget(
                            context,
                            Icons.receipt_long,
                            'Registros',
                            () {
                              context.go('/home/records');
                            },
                          ),
                        if (PermissionHelper.checkUserRolePermission(
                            _user, UserPermissions.fetchWorkers))
                          UIHelper.buttonIconAndTextWidget(
                              context, Icons.engineering, 'Trabalhadores', () {
                            context.go('/home/workers');
                          }),
                        UIHelper.buttonIconAndTextWidget(
                          context,
                          Icons.person,
                          'Alterar Perfil',
                          () {
                            context.push('/home/changeprofile');
                          },
                        ),
                        UIHelper.buttonIconAndTextWidget(
                          context,
                          Icons.person_add,
                          'Novo Perfil',
                          () {
                            context.pushNamed('registerUser');
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
