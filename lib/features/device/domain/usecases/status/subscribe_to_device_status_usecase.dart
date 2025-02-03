import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_status_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_status_repository.dart';

class SubscribeToDeviceStatusParams {
  final String deviceId;
  final String token;

  const SubscribeToDeviceStatusParams({
    required this.deviceId,
    required this.token,
  });
}

@injectable
class SubscribeToDeviceStatusUseCase
    implements
        StreamUseCase<GraphqlDataState<DeviceStatusEntity>,
            SubscribeToDeviceStatusParams> {
  final IDeviceStatusRepository _repository;

  SubscribeToDeviceStatusUseCase(this._repository);

  @override
  Stream<GraphqlDataState<DeviceStatusEntity>> execute(
      SubscribeToDeviceStatusParams params) {
    return _repository.onDeviceStatusUpdated(
      deviceId: params.deviceId,
      token: params.token,
    );
  }
}
