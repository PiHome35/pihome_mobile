import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_repository.dart';

@injectable
class GetDeviceGroupUseCase
    implements UseCase<DataState<DeviceGroupEntity>, String> {
  final IDeviceGroupRepository _repository;

  GetDeviceGroupUseCase(this._repository);

  @override
  Future<DataState<DeviceGroupEntity>> execute(String params) async {
    return await _repository.getDeviceGroup(params);
  }
}
