import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/domain/repositories/device_repository.dart';

@injectable
class DeleteDevice {
  final DeviceRepository _repository;

  DeleteDevice(this._repository);

  Future<void> call({
    required String deviceId,
    required String token,
  }) {
    return _repository.deleteDevice(
      deviceId: deviceId,
      token: token,
    );
  }
}
