import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/config/config_path.dart';
import 'package:mobile_pihome/core/error/exception.dart';
import 'package:mobile_pihome/features/device/data/models/device_model.dart';

abstract class DeviceRemoteDatasource {
  Future<List<DeviceModel>> getDevices({
    required String token,
  });
  Future<DeviceModel> getCurrentDevice({
    required String token,
  });
  Future<DeviceModel> getDeviceById({
    required String deviceId,
    required String token,
  });
  Future<void> deleteDevice({
    required String deviceId,
    required String token,
  });
  Future<DeviceModel> updateDevice({
    required String name,
    required String deviceId,
    required String token,
  });
}

@LazySingleton(as: DeviceRemoteDatasource)
class DeviceRemoteDatasourceImpl implements DeviceRemoteDatasource {
  final Dio dio;

  DeviceRemoteDatasourceImpl(this.dio);

  @override
  Future<List<DeviceModel>> getDevices({required String token}) async {
    try {
      final response = await dio.get(
        deviceCurrentFamilyUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('response get devices: ${response.data['devices']}');

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch devices',
        );
      }

      final devices = response.data['devices'];
      final List<DeviceModel> deviceModels = [];
      for (var device in devices) {
        deviceModels.add(DeviceModel.fromJson(device));
      }
      return deviceModels;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch devices',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeviceModel> getCurrentDevice({required String token}) async {
    try {
      final response = await dio.get(
        "$deviceCurrentFamilyUrl/current",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch current device',
        );
      }

      if (response.data == null) {
        throw Exception('Current device not found');
      }

      return DeviceModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data['message'] ?? 'Failed to fetch current device',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeviceModel> getDeviceById(
      {required String deviceId, required String token}) async {
    try {
      final response = await dio.get(
        "$deviceCurrentFamilyUrl/$deviceId",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch device',
        );
      }

      if (response.data == null) {
        throw ServerException(message: 'Device not found');
      }

      return DeviceModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch device',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteDevice(
      {required String deviceId, required String token}) async {
    try {
      final response = await dio.delete(
        "$deviceCurrentFamilyUrl/$deviceId",
        options: Options(
          headers: {
            'Content-Type': 'text/plain;charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to delete device',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to delete device',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeviceModel> updateDevice({
    required String name,
    required String deviceId,
    required String token,
  }) async {
    try {
      final response = await dio.put(
        "$deviceCurrentFamilyUrl/$deviceId",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'name': name,
        },
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update device',
        );
      }

      return DeviceModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to update device',
      );
    } catch (e) {
      rethrow;
    }
  }
}
