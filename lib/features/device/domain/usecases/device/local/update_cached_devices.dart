import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/data/datasources/device_local_datasource.dart';
import 'package:mobile_pihome/features/device/data/models/device_model.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';

@injectable
class UpdateCachedDevicesUseCase implements UseCase<void, List<DeviceEntity>> {
  final DeviceLocalDataSource _localDataSource;

  UpdateCachedDevicesUseCase(this._localDataSource);

  @override
  Future<void> execute(List<DeviceEntity> devices) async {
    final List<DeviceModel> deviceModels = [];
    for (DeviceEntity device in devices) {
      deviceModels.add(DeviceModel.fromEntity(device));
    }
    await _localDataSource.cacheDevices(deviceModels);
  }
}
