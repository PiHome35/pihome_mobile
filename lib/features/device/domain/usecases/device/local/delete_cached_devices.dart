import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/domain/repositories/device_repository.dart';

@injectable
class DeleteCachedDevices {
  final DeviceRepository _repository;

  DeleteCachedDevices(this._repository);

  Future<void> call() {
    return _repository.deleteCachedDevices();
  }
}
