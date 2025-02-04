import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../common/cubit/user/user_cubit.dart';
import '../constants/constants.dart';
import '../utils/role_permissions_checker.dart';
import 'widgets/services_pages_widget.dart';
import '../common/entities/user.dart';
import '../common/widgets/logo_and_help_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _user;
  late List<AppServices> _userServices;

  @override
  void initState() {
    _user = (context.read<UserCubit>().state as UserLoggedIn).user;
    _userServices = getUserServices(_user)
        .where((service) => service.path.isNotEmpty)
        .toList();
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
                    color:
                        Colors.grey.withAlpha(Color.getAlphaFromOpacity(0.5)),
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
                      children: [
                        for (var service in _userServices)
                          ServicesPagesWidget(
                            icon: service.icon,
                            text: service.name,
                            onPressed: () {
                              context.push(service.path);
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
