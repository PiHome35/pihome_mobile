import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/config/config_path.dart';
import 'package:mobile_pihome/core/data/models/user_model.dart';
import 'package:mobile_pihome/core/error/exception.dart';


abstract class UserRemoteDataSource {
  Future<UserModel> getUser({ required String token });
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;
  UserRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> getUser({ required String token }) async {
    try {
      final response = await _dio.get(
        getMeUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('response: ${response.data}');
      log('response statusCode: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data!);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeoutException();
      } else {
        log('error: ${e.response?.data}');
        throw ServerException();
      }
    }
  }
}
