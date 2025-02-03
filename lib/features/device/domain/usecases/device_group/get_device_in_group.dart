import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_repository.dart';

class GetDeviceInGroupParams {
  final String token;
  final String groupId;

  GetDeviceInGroupParams({
    required this.token,
    required this.groupId,
  });
}

@injectable
class GetDeviceInGroupUseCase
    implements UseCase<DataState<List<DeviceEntity>>, GetDeviceInGroupParams> {
  final IDeviceGroupRepository repository;

  GetDeviceInGroupUseCase(this.repository);

  @override
  Future<DataState<List<DeviceEntity>>> execute(
      GetDeviceInGroupParams params) async {
    return await repository.getDevicesInGroup(
      token: params.token,
      groupId: params.groupId,
    );
  }
}
