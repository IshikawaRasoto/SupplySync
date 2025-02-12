part of 'init_dependencies_imports.dart';

final serviceLocator = GetIt.instance;

class InitDependencies {
  static const String type = 'prod';
  static Future<void> init() async {
    _initAuth();
    _initUserActions();
    _initLog();
    _initCarts();
    _initWarehouse();
    _initNotifications();
    _initDockTransport();
    _initWarehouseTransport();

    // * Core
    // Http Client
    serviceLocator.registerLazySingleton(() => http.Client());

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

    // Services
    serviceLocator.registerLazySingleton<AuthInterceptorService>(
      () => AuthInterceptorServiceImpl(),
    );

    // Api
    serviceLocator.registerLazySingleton<ApiService>(
      () => ApiServiceImpl(
        configRepository: serviceLocator<ConfigRepository>(),
        authInterceptorService: serviceLocator<AuthInterceptorService>(),
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
      ..registerFactory<AuthCredentialsRepository>(
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

  static void _initLog() {
    serviceLocator
      // Repositories
      ..registerFactory<LogRepository>(
        () => LogRepositoryImpl(serviceLocator<UserActionsRemoteDataSource>()),
      )
      // UseCases
      ..registerFactory(() => GetLogs(serviceLocator<LogRepository>()))
      // Blocs
      ..registerLazySingleton(() => LogBloc(
            getLogs: serviceLocator<GetLogs>(),
            userCubit: serviceLocator<UserCubit>(),
          ));
  }

  static void _initCarts() {
    const String localType = type;
    serviceLocator
      // DataSources
      ..registerFactory<CartRemoteDataSource>(
          () => CartRemoteDataSourceImplMock(),
          instanceName: 'mock')
      ..registerFactory<CartRemoteDataSource>(
          () => CartRemoteDataSourceImpl(serviceLocator<ApiService>()),
          instanceName: 'prod')
      // Repositories
      ..registerFactory<CartRepository>(() => CartRepositoryImpl(
          serviceLocator<CartRemoteDataSource>(instanceName: localType)))
      // UseCases
      ..registerFactory(
          () => RequestCartUsage(serviceLocator<CartRepository>()))
      ..registerFactory(
          () => ScheduleCartMaintenance(serviceLocator<CartRepository>()))
      ..registerFactory(() => ShutdownCart(serviceLocator<CartRepository>()))
      ..registerFactory(() => GetCartDetails(serviceLocator<CartRepository>()))
      ..registerFactory(() => GetAllCarts(serviceLocator<CartRepository>()))
      ..registerFactory(
          () => RequestAnyCartUsage(serviceLocator<CartRepository>()))
      ..registerFactory(() => ReleaseDrone(serviceLocator<CartRepository>()))
      ..registerFactory(
          () => ReportCartProblem(serviceLocator<CartRepository>()))
      // Blocs
      ..registerLazySingleton(() => CartBloc(
            requestCartUse: serviceLocator<RequestCartUsage>(),
            requestCartMaintenance: serviceLocator<ScheduleCartMaintenance>(),
            requestShutdown: serviceLocator<ShutdownCart>(),
            getCartDetails: serviceLocator<GetCartDetails>(),
            getAllCarts: serviceLocator<GetAllCarts>(),
            userCubit: serviceLocator<UserCubit>(),
          ));
  }

  static void _initWarehouse() {
    final String localType = type;
    serviceLocator
      // DataSources
      ..registerFactory<WarehouseRemoteDataSource>(
          () => WarehouseRemoteDataSourceImplMock(),
          instanceName: 'mock')
      ..registerFactory<WarehouseRemoteDataSource>(
          () => WarehouseRemoteDataSourceImpl(
              apiService: serviceLocator<ApiService>()),
          instanceName: 'prod')
      // Repositories
      ..registerFactory<WarehouseRepository>(() => WarehouseRepositoryImpl(
            remoteDataSource: serviceLocator<WarehouseRemoteDataSource>(
                instanceName: localType),
          ))
      // UseCases
      ..registerFactory(
          () => GetWarehouses(serviceLocator<WarehouseRepository>()))
      ..registerFactory(() => GetWarehouseProducts(
            serviceLocator<WarehouseRepository>(),
          ))
      ..registerFactory(() => UpdateWarehouseProduct(
            serviceLocator<WarehouseRepository>(),
          ))
      ..registerFactory(() => AddWarehouseProduct(
            serviceLocator<WarehouseRepository>(),
          ))
      ..registerFactory(() => RemoveWarehouseProduct(
            serviceLocator<WarehouseRepository>(),
          ))
      // Blocs
      ..registerLazySingleton(() => WarehousesBloc(
            getWarehouses: serviceLocator<GetWarehouses>(),
            userCubit: serviceLocator<UserCubit>(),
          ))
      ..registerLazySingleton(() => WarehouseProductsBloc(
            userCubit: serviceLocator<UserCubit>(),
            getWarehouseProducts: serviceLocator<GetWarehouseProducts>(),
            updateWarehouseProduct: serviceLocator<UpdateWarehouseProduct>(),
            addWarehouseProduct: serviceLocator<AddWarehouseProduct>(),
            removeWarehouseProduct: serviceLocator<RemoveWarehouseProduct>(),
          ));
  }

  static void _initNotifications() {
    serviceLocator
      // Plugins
      ..registerLazySingleton<FlutterLocalNotificationsPlugin>(
        () => FlutterLocalNotificationsPlugin(),
      )
      ..registerLazySingleton<FirebaseMessaging>(
        () => FirebaseMessaging.instance,
      )
      // DataSources
      ..registerLazySingleton<LocalNotificationsDataSource>(
        () => LocalNotificationsDataSourceImpl(
          serviceLocator<FlutterLocalNotificationsPlugin>(),
        ),
      )
      ..registerLazySingleton<NotificationRemoteDataSource>(
        () => NotificationRemoteDataSourceImpl(
          localNotifications: serviceLocator<LocalNotificationsDataSource>(),
          firebaseMessaging: serviceLocator<FirebaseMessaging>(),
          apiService: serviceLocator<ApiService>(),
        ),
      )
      // Repository
      ..registerFactory<NotificationRepository>(
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

  static void _initDockTransport() {
    const String localType = type;
    serviceLocator
      // DataSources
      ..registerFactory<DockTransportRemoteDataSource>(
          () => DockTransportRemoteDataSourceImplMock(),
          instanceName: 'mock')
      ..registerFactory<DockTransportRemoteDataSource>(
          () => DockTransportRemoteDataSourceImpl(
              apiService: serviceLocator<ApiService>()),
          instanceName: 'prod')
      // Repositories
      ..registerFactory<DockTransportRepository>(() =>
          DockTransportRepositoryImpl(
              remoteDataSource: serviceLocator<DockTransportRemoteDataSource>(
                  instanceName: localType)))
      // UseCases
      ..registerFactory(
          () => UploadCartPhoto(serviceLocator<DockTransportRepository>()))
      // Blocs
      ..registerLazySingleton(() => DockTransportBloc(
            requestCartUsage: serviceLocator<RequestAnyCartUsage>(),
            userCubit: serviceLocator<UserCubit>(),
          ))
      ..registerLazySingleton(() => CartRequestBloc(
            userCubit: serviceLocator<UserCubit>(),
            requestCartDetails: serviceLocator<GetCartDetails>(),
            uploadCartPhoto: serviceLocator<UploadCartPhoto>(),
            releaseDrone: serviceLocator<ReleaseDrone>(),
            reportCartProblem: serviceLocator<ReportCartProblem>(),
          ));
  }

  static void _initWarehouseTransport() {
    const String localType = type;
    serviceLocator
      // DataSources
      ..registerFactory<WarehouseTransportRemoteDataSource>(
          () => WarehouseTransportRemoteDataSourceImplMock(),
          instanceName: 'mock')
      ..registerFactory<WarehouseTransportRemoteDataSource>(
          () => WarehouseTransportRemoteDataSourceImpl(
              apiService: serviceLocator<ApiService>()),
          instanceName: 'prod')
      // Repositories
      ..registerFactory<WarehouseTransportRepository>(
          () => WarehouseTransportRepositoryImpl(
                remoteDataSource:
                    serviceLocator<WarehouseTransportRemoteDataSource>(
                        instanceName: localType),
              ))
      // UseCases
      ..registerFactory(() =>
          FetchIncomingDrones(serviceLocator<WarehouseTransportRepository>()))
      ..registerFactory(() =>
          UploadDronePhoto(serviceLocator<WarehouseTransportRepository>()))
      // Blocs
      ..registerLazySingleton(() => WarehouseTransportBloc(
            userCubit: serviceLocator<UserCubit>(),
            fetchIncomingDrones: serviceLocator<FetchIncomingDrones>(),
            getWarehouses: serviceLocator<GetWarehouses>(),
          ))
      ..registerLazySingleton(() => DroneDetailsBloc(
            userCubit: serviceLocator<UserCubit>(),
            getCartDetails: serviceLocator<GetCartDetails>(),
            uploadDronePhoto: serviceLocator<UploadDronePhoto>(),
            releaseDrone: serviceLocator<ReleaseDrone>(),
          ));
  }
}
