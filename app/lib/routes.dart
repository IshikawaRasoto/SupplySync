// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'screen/change_profile_screen.dart';
import 'screen/home_screen.dart';
import 'screen/login_screen.dart';
import 'screen/warehouses_detais_screen.dart';
import 'screen/warehouses_screen.dart';

class RouterMain {
  static User _user = User();

  static User get user => _user;

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      // Redireciona para o login se o usuário não estiver autenticado e tentar acessar rotas protegidas
      // final loggedIn = await _user.checkIfUserIsLoggedIn();
      final loggedIn = true;
      final loggingIn = state.matchedLocation == '/login';

      if (!loggedIn && !loggingIn) return '/login';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        onExit: (context, state) {
          _user.clear();
          context.go('/login');
          return true;
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
            path: '/drones',
            name: 'drones',
            builder: (context, state) {
              return Container();
            },
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
            builder: (context, state) {
              return Container();
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
              return ChangeProfileScreen();
            },
          ),
        ],
      ),
    ],
  );
}
