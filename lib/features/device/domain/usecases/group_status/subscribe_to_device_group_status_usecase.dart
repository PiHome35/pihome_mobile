import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_status_entify.dart';
import 'package:mobile_pihome/features/device/domain/repositories/i_device_group_status_repository.dart';

class SubscribeToDeviceGroupStatusParams {
  final String deviceGroupId;
  final String token;

  const SubscribeToDeviceGroupStatusParams({
    required this.deviceGroupId,
    required this.token,
  });
}

@injectable
class SubscribeToDeviceGroupStatusUseCase
    implements
        StreamUseCase<GraphqlDataState<DeviceGroupStatusEntity>,
            SubscribeToDeviceGroupStatusParams> {
  final IDeviceGroupStatusRepository _repository;

  SubscribeToDeviceGroupStatusUseCase(this._repository);

  @override
  Stream<GraphqlDataState<DeviceGroupStatusEntity>> execute(
      SubscribeToDeviceGroupStatusParams params) {
    return _repository.onDeviceGroupStatusUpdated(
      deviceGroupId: params.deviceGroupId,
      token: params.token,
    );
  }
}
