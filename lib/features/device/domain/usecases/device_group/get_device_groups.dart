import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_repository.dart';

@injectable
class GetDeviceGroupsUseCase
    implements UseCase<DataState<List<DeviceGroupEntity>>, String> {
  final IDeviceGroupRepository _repository;

  GetDeviceGroupsUseCase(this._repository);

  @override
  Future<DataState<List<DeviceGroupEntity>>> execute(String token) async {
    return await _repository.getDeviceGroups(token: token);
  }
}
