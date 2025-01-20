import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/device_repository.dart';

@LazySingleton()
class CacheDevicesUseCase implements UseCase<void, List<DeviceEntity>> {
  final DeviceRepository _repository;
  CacheDevicesUseCase(this._repository);

  @override
  Future<void> execute(List<DeviceEntity> params) {
    return _repository.cacheDevices(params);
  }
}