import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/device/data/models/device_group_model.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';
import 'package:mobile_pihome/features/device/data/datasources/device_group_remote_datasource.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_repository.dart';

@LazySingleton(as: IDeviceGroupRepository)
class DeviceGroupRepositoryImpl implements IDeviceGroupRepository {
  final DeviceGroupRemoteDatasource remoteDatasource;

  DeviceGroupRepositoryImpl(this.remoteDatasource);

  @override
  Future<DataState<List<DeviceGroupEntity>>> getDeviceGroups({
    required String token,
  }) async {
    try {
      final deviceGroups = await remoteDatasource.getDeviceGroups(token: token);
      return DataSuccess(deviceGroups);
    } catch (e) {
      return DataFailed(DioException(requestOptions: RequestOptions(path: '')));
    }
  }

  @override
  Future<DataState<DeviceGroupEntity>> createDeviceGroup({
    required String name,
    required String token,
  }) async {
    try {
      final deviceGroup = await remoteDatasource.createDeviceGroup(
        name: name,
        token: token,
      );
      return DataSuccess(deviceGroup);
    } catch (e) {
      return DataFailed(DioException(requestOptions: RequestOptions(path: '')));
    }
  }

  @override
  Future<DataState<DeviceGroupEntity>> updateDeviceGroup({
    required DeviceGroupEntity group,
    required String token,
  }) async {
    try {
      final deviceGroup = await remoteDatasource.updateDeviceGroup(
        deviceGroup: DeviceGroupModel.fromEntity(group),
        token: token,
      );
      return DataSuccess(deviceGroup);
    } catch (e) {
      return DataFailed(DioException(requestOptions: RequestOptions(path: '')));
    }
  }

  @override
  Future<DataState<void>> deleteDeviceGroup({
    required String groupId,
    required String token,
  }) async {
    try {
      await remoteDatasource.deleteDeviceGroup(
        id: groupId,
        token: token,
      );
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(DioException(requestOptions: RequestOptions(path: '')));
    }
  }

  @override
  Future<DataState<DeviceGroupEntity>> getDeviceGroup({
    required String groupId,
    required String token,
  }) async {
    try {
      final deviceGroup = await remoteDatasource.getDeviceGroup(
        id: groupId,
        token: token,
      );
      log('deviceGroup: $deviceGroup');
      return DataSuccess(deviceGroup);
    } catch (e) {
      log('error: $e');
      return DataFailed(DioException(requestOptions: RequestOptions(path: '')));
    }
  }

  @override
  Future<DataState<List<DeviceEntity>>> addDevicesToGroup(
      {required String token,
      required String groupId,
      required List<String> deviceIds}) async {
    try {
      final devices = await remoteDatasource.addDevicesToGroup(
        token: token,
        groupId: groupId,
        deviceIds: deviceIds,
      );
      return DataSuccess(devices.map((device) => device.toEntity()).toList());
    } catch (e) {
      return DataFailed(DioException(requestOptions: RequestOptions(path: '')));
    }
  }

  @override
  Future<DataState<List<DeviceEntity>>> getDevicesInGroup({
    required String token,
    required String groupId,
  }) async {
    try {
      final devices = await remoteDatasource.getDevicesInGroup(
        token: token,
        groupId: groupId,
      );
      return DataSuccess(devices.map((device) => device.toEntity()).toList());
    } catch (e) {
      return DataFailed(DioException(requestOptions: RequestOptions(path: '')));
    }
  }

  @override
  Future<DataState<List<DeviceEntity>>> removeDevicesFromGroup({
    required String token,
    required String groupId,
    required List<String> deviceIds,
  }) async {
    try {
      final devices = await remoteDatasource.removeDevicesFromGroup(
        token: token,
        groupId: groupId,
        deviceIds: deviceIds,
      );
      return DataSuccess(devices.map((device) => device.toEntity()).toList());
    } catch (e) {
      return DataFailed(
        DioException(requestOptions: RequestOptions(path: '')),
      );
    }
  }
}
