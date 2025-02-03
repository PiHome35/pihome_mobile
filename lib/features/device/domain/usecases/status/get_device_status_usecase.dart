import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_status_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_status_repository.dart';

class GetDeviceStatusParams {
  final String deviceId;
  final String token;

  const GetDeviceStatusParams({
    required this.deviceId,
    required this.token,
  });
}

@injectable
class GetDeviceStatusUseCase
    implements
        UseCase<GraphqlDataState<DeviceStatusEntity>, GetDeviceStatusParams> {
  final IDeviceStatusRepository _repository;

  GetDeviceStatusUseCase(this._repository);

  @override
  Future<GraphqlDataState<DeviceStatusEntity>> execute(
      GetDeviceStatusParams params) {
    return _repository.getDeviceStatus(
      deviceId: params.deviceId,
      token: params.token,
    );
  }
}
