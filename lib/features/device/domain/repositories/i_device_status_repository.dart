import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_status_entity.dart';

abstract class IDeviceStatusRepository {
  Future<GraphqlDataState<DeviceStatusEntity>> getDeviceStatus({
    required String deviceId,
    required String token,
  });

  Future<GraphqlDataState<DeviceStatusEntity>> setDeviceMuted({
    required String deviceId,
    required bool isMuted,
    required String token,
  });

  Future<GraphqlDataState<DeviceStatusEntity>> setDeviceVolume({
    required String deviceId,
    required int volumePercent,
    required String token,
  });

  Future<GraphqlDataState<DeviceStatusEntity>> heartbeat({
    required String deviceId,
    required String token,
  });

  Stream<GraphqlDataState<DeviceStatusEntity>> onDeviceStatusUpdated({
    required String deviceId,
    required String token,
  });
}
