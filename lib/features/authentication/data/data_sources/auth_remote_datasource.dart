import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/config/config_path.dart';
import 'package:mobile_pihome/core/error/exception.dart';
import 'package:mobile_pihome/features/authentication/data/models/token_model.dart';

abstract class AuthRemoteDataSource {
  Future<TokenModel> getToken({
    required String email,
    required String password,
  });
  Future<TokenModel> registerUser({
    required String email,
    required String password,
    required String fullName,
  });
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio) {
    _dio.options.baseUrl = baseUrl;
  }

  @override
  Future<TokenModel> getToken({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        getAccessTokenUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'username': email,
          'password': password,
          'grantType': 'password',
        },
      );
      log('response: ${response.data}');
      log('response statusCode: ${response.statusCode}');
      return TokenModel.fromJson(response.data!);
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
    required String fullName,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        registerUrl,
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
        },
      );

      return TokenModel.fromJson(response.data!);
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
}
