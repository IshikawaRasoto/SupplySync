part of 'init_dependencies_imports.dart';

final serviceLocator = GetIt.instance;

class InitDependencies {
  static Future<void> init() async {
    _initAuth();
    _initUserActions();
    _initCarts();
    _initNotifications();

    // * Core
    // Local Data
    serviceLocator
      ..registerLazySingleton<LocalStorageRepository>(
        () => LocalStorageRepositoryImpl(),
        instanceName: 'non-secure',
      )
      ..registerLazySingleton<LocalStorageRepository>(
        () => SecureStorageRepositoryImpl(),
        instanceName: 'secure',
      )
      ..registerLazySingleton<ConfigRepository>(
        () => ConfigRepositoryImpl(
          nonSecureStorage: serviceLocator<LocalStorageRepository>(
              instanceName: 'non-secure'),
        ),
      )
      ..registerLazySingleton<SettingsCubit>(
        () => SettingsCubit(
          serviceLocator<ConfigRepository>(),
        ),
      );
    // Api
    serviceLocator.registerLazySingleton<ApiService>(
      () => ApiServiceImpl(
        serviceLocator<ConfigRepository>(),
      ),
    );
    // Cubits
    serviceLocator.registerLazySingleton(() => UserCubit());
  }

  static void _initAuth() {
    serviceLocator
      // DataSources
      ..registerFactory<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(serviceLocator<ApiService>()))
      // Repositories
      ..registerFactory<AuthRepository>(
          () => AuthRepositoryImpl(serviceLocator<AuthRemoteDataSource>()))
      ..registerLazySingleton<AuthCredentialsRepository>(
        () => AuthCredentialsRepositoryImpl(
          serviceLocator<LocalStorageRepository>(instanceName: 'secure'),
        ),
      )
      // UseCases
      ..registerFactory(() => UserLogin(serviceLocator<AuthRepository>()))
      ..registerFactory(() => UserLogout(serviceLocator<AuthRepository>()))
      ..registerFactory(() => UserGetUser(serviceLocator<AuthRepository>()))
      // Blocs
      ..registerLazySingleton(() => AuthBloc(
            userCubit: serviceLocator<UserCubit>(),
            loginUseCase: serviceLocator<UserLogin>(),
            logoutUseCase: serviceLocator<UserLogout>(),
            getCurrentUseCase: serviceLocator<UserGetUser>(),
          ))
      // Cubics
      ..registerLazySingleton<AuthCredentialsCubit>(
        () => AuthCredentialsCubit(
          serviceLocator<AuthCredentialsRepository>(),
        ),
      );
  }

  static void _initUserActions() {
    serviceLocator
      // DataSources
      ..registerFactory<UserActionsRemoteDataSource>(
          () => UserActionsRemoteDataSourceImpl(serviceLocator<ApiService>()))
      // Repositories
      ..registerFactory<UserActionsRepository>(() => UserActionsRepositoryImpl(
          serviceLocator<UserActionsRemoteDataSource>()))
      // UseCases
      ..registerFactory(
          () => UserUpdateProfile(serviceLocator<UserActionsRepository>()))
      ..registerFactory(
          () => UserGetUserByUserName(serviceLocator<UserActionsRepository>()))
      ..registerFactory(
          () => UserRegisterUser(serviceLocator<UserActionsRepository>()))
      ..registerFactory(
          () => UserGetAllUsers(serviceLocator<UserActionsRepository>()))
      ..registerFactory(
          () => ChangeUserRoles(serviceLocator<UserActionsRepository>()))
      // Blocs
      ..registerLazySingleton(() => UserActionsBloc(
            userCubit: serviceLocator<UserCubit>(),
            updateUseCase: serviceLocator<UserUpdateProfile>(),
            registerUseCase: serviceLocator<UserRegisterUser>(),
            changeRolesUseCase: serviceLocator<ChangeUserRoles>(),
          ))
      ..registerLazySingleton(() => UserRequestBloc(
            userCubit: serviceLocator<UserCubit>(),
            userGetUserByUserName: serviceLocator<UserGetUserByUserName>(),
            userGetAllUsers: serviceLocator<UserGetAllUsers>(),
          ));
  }

  static void _initCarts() {
    serviceLocator
      // DataSources
      ..registerFactory<CartRemoteDataSource>(() => CartRemoteDataSourceImpl(
          serviceLocator<ApiService>(), serviceLocator<UserCubit>()))
      // Repositories
      ..registerFactory<CartRepository>(
          () => CartRepositoryImpl(serviceLocator<CartRemoteDataSource>()))
      // UseCases
      ..registerFactory(
          () => RequestCartUsage(serviceLocator<CartRepository>()))
      ..registerFactory(
          () => ScheduleCartMaintenance(serviceLocator<CartRepository>()))
      ..registerFactory(() => ShutdownCart(serviceLocator<CartRepository>()))
      ..registerFactory(() => GetCartDetails(serviceLocator<CartRepository>()))
      ..registerFactory(() => GetAllCarts(serviceLocator<CartRepository>()))
      // Blocs
      ..registerLazySingleton(() => CartBloc(
            requestCartUse: serviceLocator<RequestCartUsage>(),
            requestCartMaintenance: serviceLocator<ScheduleCartMaintenance>(),
            requestShutdown: serviceLocator<ShutdownCart>(),
            getCartDetails: serviceLocator<GetCartDetails>(),
            getAllCarts: serviceLocator<GetAllCarts>(),
          ));
  }

  static void _initNotifications() {
    serviceLocator
      // DataSources
      ..registerLazySingleton<FlutterLocalNotificationsPlugin>(
        () => FlutterLocalNotificationsPlugin(),
      )
      ..registerLazySingleton<FirebaseMessaging>(
        () => FirebaseMessaging.instance,
      )
      ..registerLazySingleton<NotificationRemoteDataSource>(
        () => NotificationRemoteDataSourceImpl(
          localNotifications: LocalNotificationsDataSourceImpl(
            serviceLocator<FlutterLocalNotificationsPlugin>(),
          ),
          firebaseMessaging: serviceLocator<FirebaseMessaging>(),
          apiService: serviceLocator<ApiService>(),
        ),
      )
      // Repository
      ..registerLazySingleton<NotificationRepository>(
        () => NotificationRepositoryImpl(
          serviceLocator<NotificationRemoteDataSource>(),
        ),
      )
      // UseCases
      ..registerFactory(
        () => InitializeNotifications(serviceLocator<NotificationRepository>()),
      )
      ..registerFactory(
        () => ShowNotification(serviceLocator<NotificationRepository>()),
      )
      ..registerFactory(
        () => GetFirebaseToken(serviceLocator<NotificationRepository>()),
      )
      ..registerFactory(
        () => UpdateFirebaseToken(serviceLocator<NotificationRepository>()),
      )
      // Cubit
      ..registerLazySingleton(
        () => NotificationCubit(
          initializeNotifications: serviceLocator<InitializeNotifications>(),
          showNotification: serviceLocator<ShowNotification>(),
          getFirebaseToken: serviceLocator<GetFirebaseToken>(),
          updateFirebaseToken: serviceLocator<UpdateFirebaseToken>(),
          userCubit: serviceLocator<UserCubit>(),
        ),
      );
  }
}
