import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/config/config_path.dart';
import 'package:mobile_pihome/core/data/models/user_model.dart';
import 'package:mobile_pihome/core/error/exception.dart';
import 'package:mobile_pihome/features/family/data/models/family_model.dart';

abstract class FamilyRemoteDataSource {
  Future<FamilyModel> createFamily({
    required String name,
    required String token,
  });
  Future<String> createFamilyInviteCode({
    required String token,
  });
  Future<void> deleteFamilyInviteCode({
    required String token,
  });
  Future<List<UserModel>> listUserInCurrentFamily({
    required String token,
  });
  Future<FamilyModel?> getCurrentUserFamily({
    required String token,
  });
  Future<FamilyModel> updateCurrentUserFamily({
    required String token,
  });
  Future<FamilyModel> joinFamily({
    required String token,
    required String inviteCode,
  });
  Future<FamilyModel?> getFamilyDetail({
    required String token,
  });
}

@LazySingleton(as: FamilyRemoteDataSource)
class FamilyRemoteDataSourceImpl implements FamilyRemoteDataSource {
  final Dio _dio;

  FamilyRemoteDataSourceImpl(this._dio);

  @override
  Future<FamilyModel> createFamily(
      {required String name, required String token}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        createFamilyUrl,
        data: {
          'name': name,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 201) {
        return FamilyModel.fromJson(response.data!);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      log('[createFamily] e: $e');
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeoutException();
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<String> createFamilyInviteCode({required String token}) async {
    log('[createFamilyInviteCode] token: $token');
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        familyInviteCodeUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'text/plain;charset=UTF-8',
          },
        ),
      );
      log('[createFamilyInviteCode] response: ${response.statusCode}');
      if (response.statusCode == 201) {
        return response.data!['code'] as String;
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      log('[createFamilyInviteCode] e: $e');
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeoutException();
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<void> deleteFamilyInviteCode({required String token}) async {
    log('[deleteFamilyInviteCode] token: $token');
    try {
      final response = await _dio.delete(
        familyInviteCodeUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'text/plain;charset=UTF-8',
          },
        ),
      );
      log('[deleteFamilyInviteCode] response: ${response.data}');
      if (response.statusCode == 204) {
        return;
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      log('[deleteFamilyInviteCode] e: $e');
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeoutException();
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<FamilyModel?> getCurrentUserFamily({required String token}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        currentUserFamilyUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return FamilyModel.fromJson(response.data!);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      log('[getCurrentUserFamily] e: $e');
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeoutException();
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<List<UserModel>> listUserInCurrentFamily(
      {required String token}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        userInCurrentFamilyUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> usersJson = response.data!['users'];
        final List<UserModel> users = [];
        for (var user in usersJson) {
          users.add(UserModel.fromJson(user));
        }
        log('users: $users');
        return users;
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      log('[listUserInCurrentFamily] e: $e');
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeoutException();
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<FamilyModel> updateCurrentUserFamily({required String token}) {
    // TODO: implement updateCurrentUserFamily
    throw UnimplementedError();
  }

  @override
  Future<FamilyModel> joinFamily({
    required String token,
    required String inviteCode,
  }) async {
    log('[joinFamily] token: $token, inviteCode: $inviteCode');
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        joinFamilyUrl,
        data: {
          'code': inviteCode,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        return FamilyModel.fromJson(response.data!);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      log('[joinFamily] e: $e');
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeoutException();
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<FamilyModel?> getFamilyDetail({required String token}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        currentUserFamilyUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return FamilyModel.fromJson(response.data!);
      } else if (response.statusCode == 404) {
        log('response 404: ${response.data}');
        return null;
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      log('[getFamilyDetail] e: $e');
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeoutException();
      } else {
        throw ServerException();
      }
    }
  }
}
