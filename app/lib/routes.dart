import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:supplysync/core/helper/ui_helper.dart';
import 'package:supplysync/features/cart/presentation/screen/cart_detail_screen.dart';
import 'package:supplysync/features/cart/presentation/screen/cart_screen.dart';

import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'core/common/cubit/user/user_cubit.dart';
import 'features/user_actions/presentation/screen/change_profile_screen.dart';
import 'core/screen/home_screen.dart';
import 'features/auth/presentation/screen/login_screen.dart';
import 'features/user_actions/presentation/screen/register_user_screen.dart';
import 'features/user_actions/presentation/screen/workers_screen.dart';
import 'screen/warehouses_detais_screen.dart';
import 'screen/warehouses_screen.dart';

class RouterMain {
  static final Logger _logger = Logger();
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final isLoggedIn = context.read<UserCubit>().state is UserLoggedIn;
      final isLoggingIn = state.path == '/';
      if (!isLoggedIn && !isLoggingIn) {
        _logger.i('No user logged in, redirecting to login');
        return '/';
      }
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
            onExit: (context, state) async {
              final confirmed = await UIHelper.showDialogConfirmation(
                context,
                title: 'Sair',
                message: 'Deseja realmente sair?',
              );
              if (confirmed ?? false) {
                if (context.mounted) context.read<AuthBloc>().add(AuthLogout());
                return true;
              }
              return false;
            },
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
                  ]),
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
                builder: (context, state) {
                  return WorkersScreen();
                },
              ),
              GoRoute(
                path: '/registeruser',
                name: 'registeruser',
                builder: (context, state) {
                  return RegisterUserScreen();
                },
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
                  final targetUser = state.uri.queryParameters['targetUser'];
                  return ChangeProfileScreen(
                    targetUserName: targetUser,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
