import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/data/datasources/local/user_local_datasource.dart';
import 'package:mobile_pihome/core/data/datasources/remote/user_remote_datasource.dart';
import 'package:mobile_pihome/core/domain/entities/user.dart';
import 'package:mobile_pihome/core/domain/repositories/user_repository.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _userLocalDataSource;
  final UserRemoteDataSource _userRemoteDataSource;
  

  UserRepositoryImpl(
    this._userRemoteDataSource,
    this._userLocalDataSource,
  );

  @override
  Future<DataState<UserEntity>> getUser({required String token}) async {
    try {
      final user = await _userRemoteDataSource.getUser(token: token);
      log('fetched -> user: ${user.toString()}');
      return DataSuccess(user.toEntity());
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<UserEntity> getCachedUser() async {
    try {
      final user = await _userLocalDataSource.getSavedUser();
      return user.toEntity();
    } catch (e) {
      throw Exception('No cached user found');
    }
  }
  
  @override
  Future<void> cacheUser(UserEntity user) async {
    try {
      await _userLocalDataSource.cacheUser(user.toModel());
    } catch (e) {
      log('Failed to cache user: $e');
      throw Exception('Failed to cache user');
    }
  }
}
