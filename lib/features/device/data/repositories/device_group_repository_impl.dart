import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/device/data/datasources/mock/device_group_mock_datasource.dart';
import 'package:mobile_pihome/features/device/data/models/device_group_model.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_repository.dart';

@LazySingleton(as: IDeviceGroupRepository)
class DeviceGroupRepositoryImpl implements IDeviceGroupRepository {
  final DeviceGroupMockDatasource _dataSource;

  DeviceGroupRepositoryImpl(this._dataSource);

  @override
  Future<DataState<List<DeviceGroupEntity>>> getDeviceGroups() async {
    try {
      final result = await _dataSource.getDeviceGroups();
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<DeviceGroupEntity>> createDeviceGroup(
      DeviceGroupEntity group) async {
    try {
      final groupModel = DeviceGroupModel(
        id: group.id,
        name: group.name,
        familyId: group.familyId,
        createdAt: group.createdAt,
        updatedAt: group.updatedAt,
        icon: group.icon,
        deviceIds: group.deviceIds,
      );
      final result = await _dataSource.createDeviceGroup(groupModel);
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<DeviceGroupEntity>> updateDeviceGroup(
      DeviceGroupEntity group) async {
    try {
      final groupModel = DeviceGroupModel(
        id: group.id,
        name: group.name,
        familyId: group.familyId,
        createdAt: group.createdAt,
        updatedAt: group.updatedAt,
        icon: group.icon,
        deviceIds: group.deviceIds,
      );
      final result = await _dataSource.updateDeviceGroup(groupModel);
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> deleteDeviceGroup(String groupId) async {
    try {
      await _dataSource.deleteDeviceGroup(groupId);
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<DeviceGroupEntity>> getDeviceGroup(String groupId) async {
    try {
      final result = await _dataSource.getDeviceGroup(groupId);
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }
}
