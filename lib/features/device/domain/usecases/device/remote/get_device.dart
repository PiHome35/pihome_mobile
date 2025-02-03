import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/device_repository.dart';

@injectable
class GetDevicesUseCase implements UseCase<DataState<List<DeviceEntity>>, String> {
  final DeviceRepository _repository;
  GetDevicesUseCase(this._repository);

  @override
  Future<DataState<List<DeviceEntity>>> execute(String token) async {
    return await _repository.getDevices(token: token);
  }
}
