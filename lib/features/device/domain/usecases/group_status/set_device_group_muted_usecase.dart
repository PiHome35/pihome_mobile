import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_status_entify.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_status_repository.dart';

class SetDeviceGroupMutedParams {
  final String deviceGroupId;
  final bool isMuted;
  final String token;

  const SetDeviceGroupMutedParams({
    required this.deviceGroupId,
    required this.isMuted,
    required this.token,
  });
}

@injectable
class SetDeviceGroupMutedUseCase
    implements
        UseCase<GraphqlDataState<DeviceGroupStatusEntity>,
            SetDeviceGroupMutedParams> {
  final IDeviceGroupStatusRepository _repository;

  SetDeviceGroupMutedUseCase(this._repository);

  @override
  Future<GraphqlDataState<DeviceGroupStatusEntity>> execute(
      SetDeviceGroupMutedParams params) {
    return _repository.setDeviceGroupMuted(
      deviceGroupId: params.deviceGroupId,
      isMuted: params.isMuted,
      token: params.token,
    );
  }
}
