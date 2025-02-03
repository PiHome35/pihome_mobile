import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_status_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_status_repository.dart';

class SetDeviceVolumeParams {
  final String deviceId;
  final int volumePercent;
  final String token;

  const SetDeviceVolumeParams({
    required this.deviceId,
    required this.volumePercent,
    required this.token,
  });
}

@injectable
class SetDeviceVolumeUseCase
    implements
        UseCase<GraphqlDataState<DeviceStatusEntity>, SetDeviceVolumeParams> {
  final IDeviceStatusRepository _repository;

  SetDeviceVolumeUseCase(this._repository);

  @override
  Future<GraphqlDataState<DeviceStatusEntity>> execute(
      SetDeviceVolumeParams params) {
    return _repository.setDeviceVolume(
      deviceId: params.deviceId,
      volumePercent: params.volumePercent,
      token: params.token,
    );
  }
}
