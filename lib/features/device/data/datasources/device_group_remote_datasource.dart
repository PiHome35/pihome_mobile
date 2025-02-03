import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/config/config_path.dart';
import 'package:mobile_pihome/features/device/data/models/device_group_creation_response.dart';
import 'package:mobile_pihome/features/device/data/models/device_model.dart';
import 'package:mobile_pihome/features/device/data/models/device_group_model.dart';

abstract class DeviceGroupRemoteDatasource {
  Future<List<DeviceGroupModel>> getDeviceGroups({
    required String token,
  });
  Future<DeviceGroupModel> getDeviceGroup({
    required String token,
    required String id,
  });
  Future<DeviceGroupModel> updateDeviceGroup({
    required String token,
    required DeviceGroupModel deviceGroup,
  });
  Future<DeviceGroupModel> createDeviceGroup({
    required String name,
    required String token,
  });
  Future<void> deleteDeviceGroup({
    required String token,
    required String id,
  });
  Future<List<DeviceModel>> addDevicesToGroup({
    required String token,
    required String groupId,
    required List<String> deviceIds,
  });
  Future<List<DeviceModel>> getDevicesInGroup({
    required String token,
    required String groupId,
  });
  Future<List<DeviceModel>> removeDevicesFromGroup({
    required String token,
    required String groupId,
    required List<String> deviceIds,
  });
}

@LazySingleton(as: DeviceGroupRemoteDatasource)
class DeviceGroupRemoteDatasourceImpl implements DeviceGroupRemoteDatasource {
  final Dio _dio;

  DeviceGroupRemoteDatasourceImpl(this._dio);

  @override
  Future<List<DeviceGroupModel>> getDeviceGroups(
      {required String token}) async {
    try {
      final response = await _dio.get(
        groupDeviceUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['deviceGroups'];
        List<DeviceGroupModel> deviceGroups = [];
        for (var item in data) {
          deviceGroups.add(DeviceGroupModel.fromJson(item));
        }
        log('data: $deviceGroups');
        return deviceGroups;
      }
      throw Exception('Failed to get device groups');
    } catch (e) {
      log('error: $e');
      throw Exception('Failed to get device groups: $e');
    }
  }

  @override
  Future<DeviceGroupModel> createDeviceGroup({
    required String name,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        groupDeviceUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'name': name,
        },
      );
      log('response createDeviceGroup: ${response.data}');
      if (response.statusCode == 201) {
        final responseCreate =
            DeviceGroupCreationResponseModel.fromJson(response.data);
        final deviceGroupModel =
            DeviceGroupModel.fromJson(responseCreate.toJson());
        log('deviceGroupModel: $deviceGroupModel');
        return deviceGroupModel;
      }
      throw Exception('Failed to create device group');
    } catch (e) {
      log('error createDeviceGroup: $e');
      throw Exception('Failed to create device group: $e');
    }
  }

  @override
  Future<DeviceGroupModel> getDeviceGroup({
    required String token,
    required String id,
  }) async {
    try {
      final response = await _dio.get(
        '$groupDeviceUrl/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return DeviceGroupModel.fromJson(response.data);
      }
      throw Exception('Failed to get device group');
    } catch (e) {
      throw Exception('Failed to get device group: $e');
    }
  }

  @override
  Future<DeviceGroupModel> updateDeviceGroup({
    required String token,
    required DeviceGroupModel deviceGroup,
  }) async {
    try {
      final response = await _dio.put(
        '$groupDeviceUrl/${deviceGroup.id}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: deviceGroup.toJson(),
      );

      if (response.statusCode == 200) {
        return DeviceGroupModel.fromJson(response.data);
      }
      throw Exception('Failed to update device group');
    } catch (e) {
      throw Exception('Failed to update device group: $e');
    }
  }

  @override
  Future<void> deleteDeviceGroup({
    required String token,
    required String id,
  }) async {
    try {
      final response = await _dio.delete(
        '$groupDeviceUrl/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'text/plain;charset=UTF-8',
          },
        ),
      );
      if (response.statusCode == 204 || response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to delete device group');
      }
    } catch (e) {
      throw Exception('Failed to delete device group: $e');
    }
  }

  @override
  Future<List<DeviceModel>> addDevicesToGroup({
    required String token,
    required String groupId,
    required List<String> deviceIds,
  }) async {
    try {
      final response = await _dio.post(
        '$groupDeviceUrl/$groupId/devices/add',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'deviceIds': deviceIds,
        },
      );
      if (response.statusCode == 201) {
        final List<dynamic> devices = response.data['devices'];
        final List<DeviceModel> deviceModels = [];
        for (var item in devices) {
          deviceModels.add(DeviceModel.fromJson(item));
        }
        return deviceModels;
      } else {
        throw Exception('Failed to add devices to group:');
      }
    } catch (e) {
      log('error add devices to group: $e');
      throw Exception('Failed to add devices to group: $e');
    }
  }

  @override
  Future<List<DeviceModel>> getDevicesInGroup({
    required String token,
    required String groupId,
  }) async {
    try {
      final response = await _dio.get(
        '$groupDeviceUrl/$groupId/devices',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('response [devices in group]: ${response.data}');
      log('response [devices in group]: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> devices = response.data['devices'];
        final List<DeviceModel> deviceModels = [];
        for (var item in devices) {
          deviceModels.add(DeviceModel.fromJson(item));
        }
        log('deviceModels: $deviceModels');
        return deviceModels;
      }
      throw Exception('Failed to get devices in group');
    } catch (e) {
      throw Exception('Failed to get devices in group: $e');
    }
  }

  @override
  Future<List<DeviceModel>> removeDevicesFromGroup(
      {String? token,
      required String groupId,
      required List<String> deviceIds}) async {
    try {
      final response = await _dio.post(
        '$groupDeviceUrl/$groupId/devices/remove',
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'deviceIds': deviceIds,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> devices = data['devices'];
        return devices.map((json) => DeviceModel.fromJson(json)).toList();
      }
      throw Exception('Failed to remove devices from group');
    } catch (e) {
      throw Exception('Failed to remove devices from group: $e');
    }
  }
}
