import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/graphql/graph_exception.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/features/device/data/datasources/device_status_remote_datasource.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_status_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_status_repository.dart';

@LazySingleton(as: IDeviceStatusRepository)
class DeviceStatusRepositoryImpl implements IDeviceStatusRepository {
  final IDeviceStatusRemoteDataSource _remoteDataSource;

  DeviceStatusRepositoryImpl(this._remoteDataSource);

  @override
  Future<GraphqlDataState<DeviceStatusEntity>> getDeviceStatus({
    required String deviceId,
    required String token,
  }) async {
    try {
      final result = await _remoteDataSource.getDeviceStatus(
        deviceId: deviceId,
        token: token,
      );
      return GraphqlDataSuccess(result.toEntity());
    } catch (e) {
      if (e is GraphQLException) {
        return GraphqlDataFailed(e);
      }
      return GraphqlDataFailed(
        GraphQLException(
          message: 'Failed to get device status',
          type: e.toString().contains('UNAUTHENTICATED')
              ? GraphQLErrorType.auth
              : GraphQLErrorType.unknown,
        ),
      );
    }
  }

  @override
  Future<GraphqlDataState<DeviceStatusEntity>> setDeviceMuted({
    required String deviceId,
    required bool isMuted,
    required String token,
  }) async {
    try {
      final result = await _remoteDataSource.setDeviceMuted(
        deviceId: deviceId,
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
          message: 'Failed to set device muted',
          type: e.toString().contains('UNAUTHENTICATED')
              ? GraphQLErrorType.auth
              : GraphQLErrorType.unknown,
        ),
      );
    }
  }

  @override
  Future<GraphqlDataState<DeviceStatusEntity>> setDeviceVolume({
    required String deviceId,
    required int volumePercent,
    required String token,
  }) async {
    try {
      final result = await _remoteDataSource.setDeviceVolume(
        deviceId: deviceId,
        volumePercent: volumePercent,
        token: token,
      );
      return GraphqlDataSuccess(result.toEntity());
    } catch (e) {
      if (e is GraphQLException) {
        return GraphqlDataFailed(e);
      }
      return GraphqlDataFailed(
        GraphQLException(
          message: 'Failed to set device volume',
          type: e.toString().contains('UNAUTHENTICATED')
              ? GraphQLErrorType.auth
              : GraphQLErrorType.unknown,
        ),
      );
    }
  }

  @override
  Future<GraphqlDataState<DeviceStatusEntity>> heartbeat({
    required String deviceId,
    required String token,
  }) async {
    try {
      final result = await _remoteDataSource.heartbeat(
        deviceId: deviceId,
        token: token,
      );
      return GraphqlDataSuccess(result.toEntity());
    } catch (e) {
      if (e is GraphQLException) {
        return GraphqlDataFailed(e);
      }
      return GraphqlDataFailed(
        GraphQLException(
          message: 'Failed to send heartbeat',
          type: e.toString().contains('UNAUTHENTICATED')
              ? GraphQLErrorType.auth
              : GraphQLErrorType.unknown,
        ),
      );
    }
  }

  @override
  Stream<GraphqlDataState<DeviceStatusEntity>> onDeviceStatusUpdated({
    required String deviceId,
    required String token,
  }) {
    try {
      return _remoteDataSource
          .onDeviceStatusUpdated(
            deviceId: deviceId,
            token: token,
          )
          .map((model) => GraphqlDataSuccess(model.toEntity()))
          .handleError(
            (error) => const GraphqlDataFailed(
              GraphQLException(
                message: 'Failed to subscribe to device status updates',
                type: GraphQLErrorType.subscription,
              ),
            ),
          );
    } catch (e) {
      return Stream.value(
        const GraphqlDataFailed(
          GraphQLException(
            message: 'Failed to subscribe to device status updates',
            type: GraphQLErrorType.subscription,
          ),
        ),
      );
    }
  }
}
