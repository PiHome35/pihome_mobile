import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_repository.dart';

class GetDeviceGroupParams {
  final String groupId;
  final String token;

  GetDeviceGroupParams({required this.groupId, required this.token});
}

@injectable
class GetDeviceGroupUseCase
    implements UseCase<DataState<DeviceGroupEntity>, GetDeviceGroupParams> {
  final IDeviceGroupRepository _repository;
  GetDeviceGroupUseCase(this._repository);

  @override
  Future<DataState<DeviceGroupEntity>> execute(GetDeviceGroupParams params) async {
    return await _repository.getDeviceGroup(
      groupId: params.groupId,
      token: params.token,
    );
  }
}
