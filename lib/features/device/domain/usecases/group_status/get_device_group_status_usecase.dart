import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_status_entify.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_status_repository.dart';

class GetDeviceGroupStatusParams {
  final String deviceGroupId;
  final String token;

  const GetDeviceGroupStatusParams({
    required this.deviceGroupId,
    required this.token,
  });
}

@injectable
class GetDeviceGroupStatusUseCase
    implements
        UseCase<GraphqlDataState<DeviceGroupStatusEntity>,
            GetDeviceGroupStatusParams> {
  final IDeviceGroupStatusRepository _repository;

  GetDeviceGroupStatusUseCase(this._repository);

  @override
  Future<GraphqlDataState<DeviceGroupStatusEntity>> execute(
      GetDeviceGroupStatusParams params) {
    return _repository.getDeviceGroupStatus(
      deviceGroupId: params.deviceGroupId,
      token: params.token,
    );
  }
}
