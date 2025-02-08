import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplysync/features/user_actions/user_profiles/presentation/blocs/user_actions_bloc.dart';

import 'core/common/cubit/settings/settings_cubit.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'core/constants/constants.dart';
import 'core/theme/theme.dart';
import 'features/auth/presentation/cubit/auth_credentials_cubit.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/notifications/presentation/cubit/notification_cubit.dart';
import 'features/user_actions/dock_transport/presentation/blocs/cart_request_bloc.dart';
import 'features/user_actions/dock_transport/presentation/blocs/dock_transport_bloc.dart';
import 'features/user_actions/user_profiles/presentation/blocs/user_request_bloc.dart';
import 'features/user_actions/warehouse_transport/presentation/blocs/drone_details_bloc.dart';
import 'features/user_actions/warehouse_transport/presentation/blocs/warehouse_transport_bloc.dart';
import 'init_dependencies_imports.dart';
import 'core/common/cubit/user/user_cubit.dart';
import 'features/user_actions/log/presentation/blocs/log_bloc.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  await InitDependencies.init(); // Initialize Dependencies
  await serviceLocator<NotificationCubit>()
      .initialize(); // Initialize Notifications
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<UserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<UserActionsBloc>()),
        BlocProvider(create: (_) => serviceLocator<UserRequestBloc>()),
        BlocProvider(create: (_) => serviceLocator<SettingsCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthCredentialsCubit>()),
        BlocProvider(create: (_) => serviceLocator<LogBloc>()),
        BlocProvider(create: (_) => serviceLocator<NotificationCubit>()),
        BlocProvider(create: (_) => serviceLocator<CartBloc>()),
        BlocProvider(create: (_) => serviceLocator<DockTransportBloc>()),
        BlocProvider(create: (_) => serviceLocator<CartRequestBloc>()),
        BlocProvider(create: (_) => serviceLocator<WarehouseTransportBloc>()),
        BlocProvider(create: (_) => serviceLocator<DroneDetailsBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouterMain.router,
      debugShowCheckedModeBanner: false,
      title: MainConstants.appName,
      theme: AppTheme.theme,
    );
  }
}
