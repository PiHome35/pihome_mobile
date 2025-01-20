import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_repository.dart';

@injectable
class DeleteDeviceGroupUseCase implements UseCase<DataState<void>, String> {
  final IDeviceGroupRepository _repository;

  DeleteDeviceGroupUseCase(this._repository);

  @override
  Future<DataState<void>> execute(String params) async {
    return await _repository.deleteDeviceGroup(params);
  }
}
