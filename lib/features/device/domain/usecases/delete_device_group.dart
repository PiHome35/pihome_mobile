import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_repository.dart';

class DeleteDeviceGroupParams {
  final String groupId;
  final String token;

  DeleteDeviceGroupParams({required this.groupId, required this.token});
}

@injectable
class DeleteDeviceGroupUseCase implements UseCase<DataState<void>, DeleteDeviceGroupParams> {
  final IDeviceGroupRepository _repository;

  DeleteDeviceGroupUseCase(this._repository);

  @override
  Future<DataState<void>> execute(DeleteDeviceGroupParams params) async {
    return await _repository.deleteDeviceGroup(
      groupId: params.groupId,
      token: params.token,
    );
  }
}
