import '../../domain/entities/notification_message.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _dataSource;

  NotificationRepositoryImpl(this._dataSource);

  @override
  Future<void> initialize() => _dataSource.initialize();

  @override
  Future<void> showNotification(NotificationMessage message) =>
      _dataSource.showLocalNotification(message);

  @override
  Future<String?> getFirebaseToken() => _dataSource.getFirebaseToken();
}
