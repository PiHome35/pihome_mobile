import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/graphql/graph_exception.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/features/device/data/datasources/device_group_status_remote_datasource.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_status_entify.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_status_repository.dart';

@LazySingleton(as: IDeviceGroupStatusRepository)
class DeviceGroupStatusRepositoryImpl implements IDeviceGroupStatusRepository {
  final IDeviceGroupStatusRemoteDataSource _remoteDataSource;

  DeviceGroupStatusRepositoryImpl(this._remoteDataSource);

  @override
  Future<GraphqlDataState<DeviceGroupStatusEntity>> getDeviceGroupStatus({
    required String deviceGroupId,
    required String token,
  }) async {
    try {
      final result = await _remoteDataSource.getDeviceGroupStatus(
        deviceGroupId: deviceGroupId,
        token: token,
      );
      return GraphqlDataSuccess(result.toEntity());
    } catch (e) {
      if (e is GraphQLException) {
        return GraphqlDataFailed(e);
      }
      return GraphqlDataFailed(
        GraphQLException(
          message: 'Failed to get device group status',
          type: e.toString().contains('UNAUTHENTICATED')
              ? GraphQLErrorType.auth
              : GraphQLErrorType.unknown,
        ),
      );
    }
  }

  @override
  Future<GraphqlDataState<DeviceGroupStatusEntity>> setDeviceGroupMuted({
    required String deviceGroupId,
    required bool isMuted,
    required String token,
  }) async {
    try {
      final result = await _remoteDataSource.setDeviceGroupMuted(
        deviceGroupId: deviceGroupId,
        isMuted: isMuted,
        token: token,
      );
      return GraphqlDataSuccess(result.toEntity());
    } catch (e) {
      if (e is GraphQLException) {
        return GraphqlDataFailed(e);
      }
      return GraphqlDataFailed(
        GraphQLException(
          message: 'Failed to set device group muted',
          type: e.toString().contains('UNAUTHENTICATED')
              ? GraphQLErrorType.auth
              : GraphQLErrorType.unknown,
        ),
      );
    }
  }

  @override
  Stream<GraphqlDataState<DeviceGroupStatusEntity>> onDeviceGroupStatusUpdated({
    required String deviceGroupId,
    required String token,
  }) {
    try {
      return _remoteDataSource
          .onDeviceGroupStatusUpdated(
            deviceGroupId: deviceGroupId,
            token: token,
          )
          .map((model) => GraphqlDataSuccess(model.toEntity()))
          .handleError(
            (error) => const GraphqlDataFailed(
              GraphQLException(
                message: 'Failed to subscribe to device group status updates',
                type: GraphQLErrorType.subscription,
              ),
            ),
          );
    } catch (e) {
      return Stream.value(
        const GraphqlDataFailed(
          GraphQLException(
            message: 'Failed to subscribe to device group status updates',
            type: GraphQLErrorType.subscription,
          ),
        ),
      );
    }
  }
}
