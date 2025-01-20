import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
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
}
