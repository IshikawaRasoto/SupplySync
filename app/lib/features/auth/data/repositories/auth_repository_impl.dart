import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/error/server_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import '../source/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, User>> login(
      {required String username, required String password}) async {
    try {
      final response = await _remoteDataSource.login(
        username: username,
        password: password,
      );
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout({required String jwtToken}) async {
    try {
      await _remoteDataSource.logout(jwtToken: jwtToken);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getUser({required String jwtToken}) async {
    try {
      final response = await _remoteDataSource.getUser(jwtToken: jwtToken);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
