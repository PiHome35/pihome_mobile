
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_repository.dart';

class AddDeviceGroupParams {
  final String token;
  final String groupId;
  final List<String> deviceIds;

  AddDeviceGroupParams({
    required this.token,
    required this.groupId,
    required this.deviceIds,
  });
}


@injectable
class AddDeviceGroupUseCase implements UseCase<DataState<List<DeviceEntity>>, AddDeviceGroupParams> {
  final IDeviceGroupRepository repository;

  AddDeviceGroupUseCase(this.repository);
  
  @override
  Future<DataState<List<DeviceEntity>>> execute(AddDeviceGroupParams params) async {
    return await repository.addDevicesToGroup(
      token: params.token,
      groupId: params.groupId,
      deviceIds: params.deviceIds,
    );
  }
}
