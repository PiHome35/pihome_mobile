import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/authentication/data/data_sources/token_local_datasource.dart';
// import 'package:mobile_pihome/features/authentication/data/models/auth_user_model.dart';
import 'package:mobile_pihome/features/authentication/domain/entities/auth_user.dart';
import 'package:mobile_pihome/features/authentication/domain/entities/token.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/authentication/domain/repositories/auth_repositories.dart';
import 'package:mobile_pihome/features/authentication/data/data_sources/auth_remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenLocalDataSource _tokenLocalDataSource;
  AuthRepositoryImpl(
    this._remoteDataSource,
    this._tokenLocalDataSource,
  );

  @override
  Future<DataState<TokenResponseEntity>> login({
    required String email,
    required String password,
    required String accessToken,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
        accessToken: accessToken,
      );

      // Save token to secure storage
      await _tokenLocalDataSource.storageToken(response.accessToken);
      return DataSuccess(response.toEntity());
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<bool>> checkAuth() async {
    try {
      final token = await _tokenLocalDataSource.getToken();
      if (token.isEmpty) {
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
    await _tokenLocalDataSource.storageToken(token);
  }

  @override
  Future<DataState<TokenResponseEntity>> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _remoteDataSource.registerUser(
        email: email,
        password: password,
        name: name,
      );
      log('response: ${response.accessToken}');


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

  @override
  Future<DataState<AuthUserEntity>> getMe({required String accessToken}) async {
    try {
      final response = await _remoteDataSource.getMe(accessToken: accessToken);
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

  @override
  Future<String> getStorageToken() async {
    final token = await _tokenLocalDataSource.getToken();
    return token;
  }
}
