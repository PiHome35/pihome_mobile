import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/authentication/domain/entities/token.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../data_sources/auth_remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<DataState<TokenResponseEntity>> getToken({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.getToken(
        email: email,
        password: password,
      );

      // Save token to secure storage
      await _secureStorage.saveAccessToken(response.accessToken);
      return DataSuccess(response.toEntity());
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<bool>> checkAuth() async {
    try {
      final token = await _secureStorage.getAccessToken();
      if (token == null) {
        return const DataSuccess(false);
      }

      return const DataSuccess(true);
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
  Future<void> storageToken(String token) async {
    await _secureStorage.saveAccessToken(token);
  }

  @override
  Future<DataState<TokenResponseEntity>> registerUser({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _remoteDataSource.registerUser(
        email: email,
        password: password,
        fullName: fullName,
      );

      return DataSuccess(response.toEntity());
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }
}
