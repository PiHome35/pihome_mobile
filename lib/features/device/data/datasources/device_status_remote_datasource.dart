import 'dart:developer';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/graphql/graphql_config.dart';
import 'package:mobile_pihome/features/device/data/models/device_status_model.dart';

abstract class IDeviceStatusRemoteDataSource {
  Future<DeviceStatusModel> getDeviceStatus({
    required String deviceId,
    required String token,
  });

  Future<DeviceStatusModel> setDeviceMuted({
    required String deviceId,
    required bool isMuted,
    required String token,
  });

  Future<DeviceStatusModel> setDeviceVolume({
    required String deviceId,
    required int volumePercent,
    required String token,
  });

  Future<DeviceStatusModel> heartbeat({
    required String deviceId,
    required String token,
  });

  Stream<DeviceStatusModel> onDeviceStatusUpdated({
    required String deviceId,
    required String token,
  });
}

// @LazySingleton(as: IDeviceStatusRemoteDataSource)
class DeviceStatusRemoteDataSource implements IDeviceStatusRemoteDataSource {
  final GraphQLConfig _graphQLConfig;

  DeviceStatusRemoteDataSource(this._graphQLConfig);

  @override
  Future<DeviceStatusModel> getDeviceStatus({
    required String deviceId,
    required String token,
  }) async {
    final result = await _graphQLConfig.clientWithToken(token).query(
          QueryOptions(
            document: gql('''
              query GetDeviceStatus(\$deviceId: String!) {
                getDeviceStatus(deviceId: \$deviceId) {
                  id
                  macAddress
                  name
                  isOn
                  isMuted
                  volumePercent
                  isSoundServer
                }
              }
            '''),
            variables: {'deviceId': deviceId},
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        );

    if (result.hasException) {
      log('Error in getDeviceStatus: ${result.exception}');
      throw result.exception!;
    }

    return DeviceStatusModel.fromJson(result.data!['getDeviceStatus']);
  }

  @override
  Future<DeviceStatusModel> setDeviceMuted({
    required String deviceId,
    required bool isMuted,
    required String token,
  }) async {
    final result = await _graphQLConfig.clientWithToken(token).mutate(
          MutationOptions(
            document: gql('''
              mutation SetDeviceMuted(\$input: SetMuteDeviceInput!) {
                setDeviceMuted(input: \$input) {
                  id
                  macAddress
                  name
                  isOn
                  isMuted
                  volumePercent
                  isSoundServer
                }
              }
            '''),
            variables: {
              'input': {
                'deviceId': deviceId,
                'isMuted': isMuted,
              },
            },
          ),
        );

    if (result.hasException) {
      throw result.exception!;
    }

    return DeviceStatusModel.fromJson(result.data!['setDeviceMuted']);
  }

  @override
  Future<DeviceStatusModel> setDeviceVolume({
    required String deviceId,
    required int volumePercent,
    required String token,
  }) async {
    final result = await _graphQLConfig.clientWithToken(token).mutate(
          MutationOptions(
            document: gql('''
              mutation SetDeviceVolume(\$input: SetVolumeDeviceInput!) {
                setDeviceVolume(input: \$input) {
                  id
                  macAddress
                  name
                  isOn
                  isMuted
                  volumePercent
                  isSoundServer
                }
              }
            '''),
            variables: {
              'input': {
                'deviceId': deviceId,
                'volumePercent': volumePercent,
              },
            },
          ),
        );

    if (result.hasException) {
      throw result.exception!;
    }

    return DeviceStatusModel.fromJson(result.data!['setDeviceVolume']);
  }

  @override
  Future<DeviceStatusModel> heartbeat({
    required String deviceId,
    required String token,
  }) async {
    final result = await _graphQLConfig.clientWithToken(token).mutate(
          MutationOptions(
            document: gql('''
              mutation Heartbeat(\$deviceId: String!) {
                heartbeat(deviceId: \$deviceId) {
                  id
                  macAddress
                  name
                  isOn
                  isMuted
                  volumePercent
                  isSoundServer
                }
              }
            '''),
            variables: {'deviceId': deviceId},
          ),
        );

    if (result.hasException) {
      throw result.exception!;
    }

    return DeviceStatusModel.fromJson(result.data!['heartbeat']);
  }

  @override
  Stream<DeviceStatusModel> onDeviceStatusUpdated({
    required String deviceId,
    required String token,
  }) {
    final operation = _graphQLConfig.clientWithToken(token).subscribe(
          SubscriptionOptions(
            document: gql('''
              subscription OnDeviceStatusUpdated(\$deviceId: String!) {
                deviceStatusUpdated(deviceId: \$deviceId) {
                  id
                  macAddress
                  name
                  isOn
                  isMuted
                  volumePercent
                  isSoundServer
                }
              }
            '''),
            variables: {'deviceId': deviceId},
          ),
        );

    return operation.map((result) {
      if (result.hasException) {
        throw result.exception!;
      }
      return DeviceStatusModel.fromJson(result.data!['deviceStatusUpdated']);
    });
  }
}
