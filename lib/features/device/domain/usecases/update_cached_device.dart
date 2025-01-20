import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/device_repository.dart';

@LazySingleton()
class UpdateCachedDeviceUseCase implements UseCase<void, DeviceEntity> {
  final DeviceRepository _repository;

  UpdateCachedDeviceUseCase(this._repository);

  @override
  Future<void> execute(DeviceEntity params) {
    return _repository.updateCachedDevice(params);
  }
}