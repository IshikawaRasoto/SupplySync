import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supplysync/helper/ui_helper.dart';

import 'models/user.dart';
import 'screen/change_profile_screen.dart';
import 'screen/home_screen.dart';
import 'screen/login_screen.dart';
import 'screen/register_user_screen.dart';
import 'screen/warehouses_detais_screen.dart';
import 'screen/warehouses_screen.dart';
import 'screen/cart_screen.dart';
import 'screen/cart_detail_screen.dart';
import 'screen/workers_screen.dart';

class RouterMain {
  static final User _user = User();

  static User get user => _user;

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // Redireciona para o login se o usuário não estiver autenticado e tentar acessar rotas protegidas
      final loggedIn = await _user.checkIfUserIsLoggedIn();
      final loggingIn = state.matchedLocation == '/';

      if (!loggedIn && !loggingIn) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) {
          return LoginScreen();
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            onExit: (context, state) async =>
                await UIHelper.showDialogConfirmation(context,
                    title: 'Sair',
                    message: 'Deseja realmente sair?',
                    onConfirm: () => _user.clear()) ??
                false,
            builder: (context, state) {
              return HomeScreen();
            },
            routes: [
              GoRoute(
                path: '/docks',
                name: 'docks',
                builder: (context, state) {
                  return Container();
                },
              ),
              GoRoute(
                path: '/carts',
                name: 'carts',
                builder: (context, state) {
                  return CartScreen();
                },
								routes: [
                  GoRoute(
                    path: '/:cartId',
                    name: 'cartDetails',
                    redirect: (context, state) {
                      final cartId = state.pathParameters['cartId']!;
                      if (cartId.isEmpty) {
                        return '/home/carts';
                      }
                      return null;
                    },
                    builder: (context, state) {
                      final cartId = state.pathParameters['cartId']!;
                      return CartDetailScreen(cartId: cartId);
                    },
                  ),
								]
              ),
              GoRoute(
                path: '/records',
                name: 'records',
                builder: (context, state) {
                  return Container();
                },
              ),
              GoRoute(
                path: '/workers',
                name: 'workers',
                builder: (context, state) => const WorkersScreen(),
                routes: [
                  GoRoute(
                    path: '/registeruser',
                    name: 'registerUser',
                    builder: (context, state) => const RegisterUserScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: '/warehouses',
                name: 'warehouses',
                builder: (context, state) => WarehousesScreen(),
                routes: [
                  GoRoute(
                    path: '/:warehouseId',
                    name: 'warehouseDetails',
                    redirect: (context, state) {
                      final warehouseId = state.pathParameters['warehouseId']!;
                      if (warehouseId.isEmpty) {
                        return '/home/warehouses';
                      }
                      return null;
                    },
                    builder: (context, state) {
                      final warehouseId = state.pathParameters['warehouseId']!;
                      return WarehouseDetailsScreen(id: warehouseId);
                    },
                  ),
                ],
              ),
              GoRoute(
                path: '/changeprofile',
                name: 'changeProfile',
                builder: (context, state) {
									final workerId = state.extra as String?; // Get worker ID from extra
									return ChangeProfileScreen(workerId: workerId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
