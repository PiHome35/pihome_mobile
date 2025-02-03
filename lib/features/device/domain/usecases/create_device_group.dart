import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_repository.dart';

class CreateDeviceGroupParams {
  final String name;
  final String token;

  CreateDeviceGroupParams({
    required this.name,
    required this.token,
  });
}

@injectable
class CreateDeviceGroupUseCase
    implements UseCase<DataState<DeviceGroupEntity>, CreateDeviceGroupParams> {
  final IDeviceGroupRepository _repository;

  CreateDeviceGroupUseCase(this._repository);

  @override
  Future<DataState<DeviceGroupEntity>> execute(
      CreateDeviceGroupParams params) async {
    return await _repository.createDeviceGroup(
      name: params.name,
      token: params.token,
    );
  }
}
