import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/data/datasources/device_local_datasource.dart';
import 'package:mobile_pihome/features/device/data/datasources/device_remote_datasource.dart';
import 'package:mobile_pihome/features/device/data/models/device_model.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/device_repository.dart';

@Environment('mock')
@LazySingleton(as: DeviceRepository)
class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceDatasource _datasource;
  final DeviceLocalDataSource _localDataSource;

  DeviceRepositoryImpl(
    this._datasource,
    this._localDataSource,
  );

  @override
  Future<List<DeviceEntity>> getDevices() async {
    final devices = await _datasource.getDevices();
    return devices.map((model) => model.toEntity()).toList();
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
