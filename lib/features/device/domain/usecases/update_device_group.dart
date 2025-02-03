import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_repository.dart';

class UpdateDeviceGroupParams {
  final DeviceGroupEntity group;
  final String token;

  UpdateDeviceGroupParams({required this.group, required this.token});
}

@injectable
class UpdateDeviceGroupUseCase
    implements UseCase<DataState<DeviceGroupEntity>, UpdateDeviceGroupParams> {
  final IDeviceGroupRepository _repository;

  UpdateDeviceGroupUseCase(this._repository);

  @override
  Future<DataState<DeviceGroupEntity>> execute(
      UpdateDeviceGroupParams params) async {
    return await _repository.updateDeviceGroup(
      group: params.group,
      token: params.token,
    );
  }
}
