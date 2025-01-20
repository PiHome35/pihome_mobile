import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/device_repository.dart';

@injectable
class FetchDeviceUseCase implements UseCase<List<DeviceEntity>, void> {
  final DeviceRepository _repository;
  FetchDeviceUseCase(this._repository);

  @override
  Future<List<DeviceEntity>> execute(void params) async {
    return await _repository.getDevices();
  }
}
