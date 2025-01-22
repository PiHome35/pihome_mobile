import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/config/config_path.dart';
import 'package:mobile_pihome/core/error/exception.dart';
import 'package:mobile_pihome/features/authentication/data/models/auth_user_model.dart';
import 'package:mobile_pihome/features/authentication/data/models/token_model.dart';

abstract class AuthRemoteDataSource {
  Future<TokenModel> login({
    required String email,
    required String password,
  });
  Future<TokenModel> registerUser({
    required String email,
    required String password,
    required String name,
  });
  Future<AuthUserModel> getMe({
    required String accessToken,
  });
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<TokenModel> login({
    required String email,
    required String password,
  }) async {
    log('email [login]: $email');
    log('password [login]: $password');
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        getAccessTokenUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TokenModel.fromJson(response.data!);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      log('e: $e');
      if (e.type == DioExceptionType.connectionTimeout) {
        log('[getToken] Connection timeout');
        throw ConnectionTimeoutException();
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<TokenModel> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        registerUrl,
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final tokenResponseJson = response.data!['login'];
        return TokenModel.fromJson(tokenResponseJson);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      log('e: $e');
      if (e.type == DioExceptionType.connectionTimeout) {
        log('[registerUser] Connection timeout');
        throw ConnectionTimeoutException();
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<AuthUserModel> getMe({
    required String accessToken,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      getMeUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    return AuthUserModel.fromJson(response.data!);
  }
}
