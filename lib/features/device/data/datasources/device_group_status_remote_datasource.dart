import 'dart:developer';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/graphql/graphql_config.dart';
import 'package:mobile_pihome/features/device/data/models/device_group_status_model.dart';

abstract class IDeviceGroupStatusRemoteDataSource {
  Future<DeviceGroupStatusModel> getDeviceGroupStatus({
    required String deviceGroupId,
    required String token,
  });

  Future<DeviceGroupStatusModel> setDeviceGroupMuted({
    required String deviceGroupId,
    required bool isMuted,
    required String token,
  });

  Stream<DeviceGroupStatusModel> onDeviceGroupStatusUpdated({
    required String deviceGroupId,
    required String token,
  });
}

class DeviceGroupStatusRemoteDataSource
    implements IDeviceGroupStatusRemoteDataSource {
  final GraphQLConfig _graphQLConfig;

  DeviceGroupStatusRemoteDataSource(this._graphQLConfig);

  @override
  Future<DeviceGroupStatusModel> getDeviceGroupStatus({
    required String deviceGroupId,
    required String token,
  }) async {
    final result = await _graphQLConfig.clientWithToken(token).query(
          QueryOptions(
            document: gql('''
              query GetDeviceGroupStatus(\$deviceGroupId: String!) {
                getDeviceGroupStatus(deviceGroupId: \$deviceGroupId) {
                  id
                  name
                  isMuted
                  devices {
                    id
                    macAddress
                    name
                    isOn
                    isMuted
                    volumePercent
                    isSoundServer
                  }
                }
              }
            '''),
            variables: {'deviceGroupId': deviceGroupId},
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        );

    if (result.hasException) {
      log('Error in getDeviceGroupStatus: ${result.exception}');
      throw result.exception!;
    }

    return DeviceGroupStatusModel.fromJson(
        result.data!['getDeviceGroupStatus']);
  }

  @override
  Future<DeviceGroupStatusModel> setDeviceGroupMuted({
    required String deviceGroupId,
    required bool isMuted,
    required String token,
  }) async {
    final result = await _graphQLConfig.clientWithToken(token).mutate(
          MutationOptions(
            document: gql('''
              mutation SetDeviceGroupMuted(\$input: SetMuteGroupInput!) {
                setDeviceGroupMuted(input: \$input) {
                  id
                  name
                  isMuted
                  devices {
                    id
                    macAddress
                    name
                    isOn
                    isMuted
                    volumePercent
                    isSoundServer
                  }
                }
              }
            '''),
            variables: {
              'input': {
                'deviceGroupId': deviceGroupId,
                'isMuted': isMuted,
              },
            },
          ),
        );

    if (result.hasException) {
      throw result.exception!;
    }

    return DeviceGroupStatusModel.fromJson(result.data!['setDeviceGroupMuted']);
  }

  @override
  Stream<DeviceGroupStatusModel> onDeviceGroupStatusUpdated({
    required String deviceGroupId,
    required String token,
  }) {
    final operation = _graphQLConfig.clientWithToken(token).subscribe(
          SubscriptionOptions(
            document: gql('''
              subscription OnDeviceGroupStatusUpdated(\$deviceGroupId: String!) {
                deviceGroupStatusUpdated(deviceGroupId: \$deviceGroupId) {
                  id
                  name
                  isMuted
                  devices {
                    id
                    macAddress
                    name
                    isOn
                    isMuted
                    volumePercent
                    isSoundServer
                  }
                }
              }
            '''),
            variables: {'deviceGroupId': deviceGroupId},
          ),
        );

    return operation.map((result) {
      if (result.hasException) {
        throw result.exception!;
      }
      return DeviceGroupStatusModel.fromJson(
          result.data!['deviceGroupStatusUpdated']);
    });
  }
}
