import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_status_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_status_repository.dart';

class SetDeviceMutedParams {
  final String deviceId;
  final bool isMuted;
  final String token;

  const SetDeviceMutedParams({
    required this.deviceId,
    required this.isMuted,
    required this.token,
  });
}

@injectable
class SetDeviceMutedUseCase
    implements
        UseCase<GraphqlDataState<DeviceStatusEntity>, SetDeviceMutedParams> {
  final IDeviceStatusRepository _repository;

  SetDeviceMutedUseCase(this._repository);

  @override
  Future<GraphqlDataState<DeviceStatusEntity>> execute(
      SetDeviceMutedParams params) {
    return _repository.setDeviceMuted(
      deviceId: params.deviceId,
      isMuted: params.isMuted,
      token: params.token,
    );
  }
}
