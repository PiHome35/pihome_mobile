import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/device/domain/repositories/ble_setup_repository.dart';

@injectable
class ReadClientIdUseCase implements UseCase<String, void> {
  final BleSetupRepository repository;

  ReadClientIdUseCase(this.repository);

  @override
  Future<String> execute(void input) {
    return repository.readClientId();
  }
}

@injectable
class ReadMacAddressUseCase implements UseCase<String, void> {
  final BleSetupRepository repository;

  ReadMacAddressUseCase(this.repository);

  @override
  Future<String> execute(void input) {
    return repository.readMacAddress();
  }
}

@injectable
class WriteClientSecretUseCase implements UseCase<void, String> {
  final BleSetupRepository repository;

  WriteClientSecretUseCase(this.repository);

  @override
  Future<void> execute(String input) {
    return repository.writeClientSecret(input);
  }
}

@injectable
class WriteWifiSsidUseCase implements UseCase<void, String> {
  final BleSetupRepository repository;

  WriteWifiSsidUseCase(this.repository);

  @override
  Future<void> execute(String input) {
    return repository.writeWifiSsid(input);
  }
}

@injectable
class WriteWifiPasswordUseCase implements UseCase<void, String> {
  final BleSetupRepository repository;

  WriteWifiPasswordUseCase(this.repository);

  @override
  Future<void> execute(String input) {
    return repository.writeWifiPassword(input);
  }
}

@injectable
class TriggerWifiConnectUseCase implements UseCase<void, void> {
  final BleSetupRepository repository;

  TriggerWifiConnectUseCase(this.repository);

  @override
  Future<void> execute(void input) {
    return repository.triggerWifiConnect();
  }
}

@injectable
class CheckSetupCompletedUseCase implements UseCase<bool, void> {
  final BleSetupRepository repository;

  CheckSetupCompletedUseCase(this.repository);

  @override
  Future<bool> execute(void input) {
    return repository.checkSetupCompleted();
  }
}
