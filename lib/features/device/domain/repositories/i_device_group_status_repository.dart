import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_status_entify.dart';

abstract class IDeviceGroupStatusRepository {
  Future<GraphqlDataState<DeviceGroupStatusEntity>> getDeviceGroupStatus({
    required String deviceGroupId,
    required String token,
  });

  Future<GraphqlDataState<DeviceGroupStatusEntity>> setDeviceGroupMuted({
    required String deviceGroupId,
    required bool isMuted,
    required String token,
  });

  Stream<GraphqlDataState<DeviceGroupStatusEntity>> onDeviceGroupStatusUpdated({
    required String deviceGroupId,
    required String token,
  });
}
