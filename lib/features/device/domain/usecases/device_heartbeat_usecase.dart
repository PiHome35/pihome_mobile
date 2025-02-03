import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_status_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_status_repository.dart';

class DeviceHeartbeatParams {
  final String deviceId;
  final String token;

  const DeviceHeartbeatParams({
    required this.deviceId,
    required this.token,
  });
}

@injectable
class DeviceHeartbeatUseCase
    implements
        UseCase<GraphqlDataState<DeviceStatusEntity>, DeviceHeartbeatParams> {
  final IDeviceStatusRepository _repository;

  DeviceHeartbeatUseCase(this._repository);

  @override
  Future<GraphqlDataState<DeviceStatusEntity>> execute(
      DeviceHeartbeatParams params) {
    return _repository.heartbeat(
      deviceId: params.deviceId,
      token: params.token,
    );
  }
}
