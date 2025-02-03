import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/device/data/datasources/device_local_datasource.dart';
import 'package:mobile_pihome/features/device/data/datasources/device_remote_datasource.dart';
import 'package:mobile_pihome/features/device/data/models/device_model.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/device_repository.dart';

@LazySingleton(as: DeviceRepository)
class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDatasource _deviceRemoteDatasource;
  final DeviceLocalDataSource _localDataSource;

  DeviceRepositoryImpl(
    this._deviceRemoteDatasource,
    this._localDataSource,
  );

  @override
  Future<DataState<List<DeviceEntity>>> getDevices({required String token}) async {
    log('call getDevices');
    try {
      final devices = await _deviceRemoteDatasource.getDevices(token: token);
      log('devices: $devices');
      final List<DeviceEntity> deviceEntities = [];
      for (DeviceModel device in devices) {
        deviceEntities.add(device.toEntity());
      }
      return DataSuccess(deviceEntities);
    } catch (e) {
      return DataFailed(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(requestOptions: RequestOptions(path: '')),
        message: e.toString(),
      ));
    }
  }

  @override
  Future<DataState<DeviceEntity>> getCurrentDevice({required String token}) async {
    try {
      final device = await _deviceRemoteDatasource.getCurrentDevice(token: token);
      return DataSuccess(device.toEntity());
    } catch (e) {
      return DataFailed(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(requestOptions: RequestOptions(path: '')),
        message: e.toString(),
      ));
    }
  }

  @override
  Future<DataState<DeviceEntity>> getDeviceById({
    required String deviceId,
    required String token,
  }) async {
    try {
      final device = await _deviceRemoteDatasource.getDeviceById(
        deviceId: deviceId,
        token: token,
      );
      return DataSuccess(device.toEntity());
    } catch (e) {
      return DataFailed(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(requestOptions: RequestOptions(path: '')),
        message: e.toString(),
      ));
    }
  }

  @override
  Future<DataState<void>> deleteDevice({
    required String deviceId,
    required String token,
  }) async {
    try {
      await _deviceRemoteDatasource.deleteDevice(
        deviceId: deviceId,
        token: token,
      );
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(requestOptions: RequestOptions(path: '')),
        message: e.toString(),
      ));
    }
  }

  @override
  Future<DataState<DeviceEntity>> updateDevice({
    required String name,
    required String deviceId,
    required String token,
  }) async {
    try {
      final device = await _deviceRemoteDatasource.updateDevice(
        name: name,
        deviceId: deviceId,
        token: token,
      );
      return DataSuccess(device.toEntity());
    } catch (e) {
      return DataFailed(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(requestOptions: RequestOptions(path: '')),
        message: e.toString(),
      ));
    }
  }

  @override
  Future<void> cacheDevices(List<DeviceEntity> devices) {
    List<DeviceModel> models = [];
    for (DeviceEntity device in devices) {
      models.add(DeviceModel.fromEntity(device));
    }
    return _localDataSource.cacheDevices(models);
  }

  @override
  Future<void> deleteCachedDevices() {
    return _localDataSource.deleteCachedDevices();
  }

  @override
  Future<List<DeviceEntity>> getCachedDevices() async {
    final models = await _localDataSource.getCachedDevices();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateCachedDevice(DeviceEntity device) {
    final DeviceModel model = DeviceModel.fromEntity(device);
    return _localDataSource.updateCachedDevice(model);
  }
}
