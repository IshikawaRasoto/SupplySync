import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/notification_channel.dart';
import '../../domain/entities/notification_message.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_storage_data_source.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _dataSource;
  final LocalStorageDataSource _localStorageDataSource;

  NotificationRepositoryImpl({
    required NotificationRemoteDataSource dataSource,
    required LocalStorageDataSource localStorageDataSource,
  })  : _dataSource = dataSource,
        _localStorageDataSource = localStorageDataSource;

  @override
  Future<void> initialize() => _dataSource.initialize();

  @override
  Future<void> showNotification(NotificationMessage message) =>
      _dataSource.showLocalNotification(message);

  @override
  Future<String?> getFirebaseToken() => _dataSource.getFirebaseToken();

  @override
  Future<void> updateFirebaseToken(
      {required String firebaseToken, required String jwtToken}) async {
    return await _dataSource.updateFirebaseToken(
        firebaseToken: firebaseToken, jwtToken: jwtToken);
  }

  @override
  Future<Either<Failure, bool?>> getChannelEnabledState(
      NotificationChannel channel) async {
    try {
      final enabled = await _localStorageDataSource
          .readBool(_getChannelEnabledKey(channel));
      return Right(enabled);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveChannelEnabledState(
      NotificationChannel channel, bool enabled) async {
    try {
      await _localStorageDataSource.writeBool(
          _getChannelEnabledKey(channel), enabled);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  String _getChannelEnabledKey(NotificationChannel channel) {
    return 'channel_enabled_${channel.id}';
  }
}
