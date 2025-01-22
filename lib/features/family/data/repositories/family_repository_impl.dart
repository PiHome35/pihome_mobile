import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/domain/entities/user.dart';
import 'package:mobile_pihome/core/error/exception.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/family/data/datasources/family_remote_datasource.dart';
import 'package:mobile_pihome/features/family/domain/entities/family_entity.dart';
import 'package:mobile_pihome/features/family/domain/repositories/family_repository.dart';

@LazySingleton(as: FamilyRepository)
class FamilyRepositoryImpl implements FamilyRepository {
  final FamilyRemoteDataSource remoteDataSource;

  FamilyRepositoryImpl(this.remoteDataSource);

  @override
  Future<DataState<FamilyEntity>> createFamily({
    required String name,
    required String token,
  }) async {
    try {
      final result = await remoteDataSource.createFamily(
        name: name,
        token: token,
      );
      return DataSuccess(result.toEntity());
    } on ServerException catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    } on ConnectionTimeoutException catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<FamilyEntity>> joinFamily({
    required String inviteCode,
    required String token,
  }) async {
    try {
      final result = await remoteDataSource.joinFamily(
        inviteCode: inviteCode,
        token: token,
      );
      return DataSuccess(result.toEntity());
    } catch (e) {
      return DataFailed(DioException(
          requestOptions: RequestOptions(path: ''), error: e.toString()));
    }
  }

  @override
  Future<DataState<String>> createFamilyInviteCode({
    required String token,
  }) async {
    try {
      final result =
          await remoteDataSource.createFamilyInviteCode(token: token);
      log('[createFamilyInviteCode] result: $result');
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(DioException(
          requestOptions: RequestOptions(path: ''), error: e.toString()));
    }
  }

  @override
  Future<DataState<void>> deleteInviteCode({required String token}) async {
    try {
      await remoteDataSource.deleteFamilyInviteCode(token: token);
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(DioException(
          requestOptions: RequestOptions(path: ''), error: e.toString()));
    }
  }

  @override
  Future<DataState<List<UserEntity>>> getFamilyMembers(
      {required String token}) async {
    try {
      final result =
          await remoteDataSource.listUserInCurrentFamily(token: token);
      log('result list user family: $result');
      return DataSuccess(result.map((e) => e.toEntity()).toList());
    } catch (e) {
      log('error list user family: $e');
      return DataFailed(DioException(
          requestOptions: RequestOptions(path: ''), error: e.toString()));
    }
  }

  @override
  Future<DataState<FamilyEntity?>> getFamilyDetail(
      {required String token}) async {
    try {
      final result = await remoteDataSource.getFamilyDetail(token: token);
      log('result family detail: $result');
      if (result == null) {
        log('result family null: $result');
        return const DataSuccess(null);
      }
      return DataSuccess(result.toEntity());
    } catch (e) {
      log('error family detail: $e');
      return DataFailed(DioException(
          requestOptions: RequestOptions(path: ''), error: e.toString()));
    }
  }
}
