import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/device_repository.dart';

@LazySingleton()
class GetCachedDevicesUseCase implements UseCase<List<DeviceEntity>, void> {
  final DeviceRepository _repository;

  GetCachedDevicesUseCase(this._repository);

  @override
  Future<List<DeviceEntity>> execute(void params) {
    return _repository.getCachedDevices();
  }
}
