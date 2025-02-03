import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/authentication/domain/entities/register_device_entity.dart';
import 'package:mobile_pihome/features/authentication/domain/entities/register_device_response_entity.dart';
import 'package:mobile_pihome/features/authentication/domain/repositories/auth_repositories.dart';

class RegisterDeviceParams {
  final String accessToken;
  final String clientId;
  final String macAddress;
  final String name;

  const RegisterDeviceParams({
    required this.accessToken,
    required this.clientId,
    required this.macAddress,
    required this.name,
  });
}

@LazySingleton()
class RegisterDeviceUseCase
    implements UseCase<DataState<RegisterDeviceResponseEntity>, RegisterDeviceParams> {
  final AuthRepository _authRepository;

  RegisterDeviceUseCase(this._authRepository);

  @override
  Future<DataState<RegisterDeviceResponseEntity>> execute(
      RegisterDeviceParams params) async {
    return _authRepository.registerDevice(
      accessToken: params.accessToken,
      clientId: params.clientId,
      macAddress: params.macAddress,
      name: params.name,
    );
  }
}
