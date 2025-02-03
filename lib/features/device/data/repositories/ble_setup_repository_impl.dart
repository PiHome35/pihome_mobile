import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/data/datasources/ble_setup_datasource.dart';
import 'package:mobile_pihome/features/device/domain/repositories/ble_setup_repository.dart';

@LazySingleton(as: BleSetupRepository)
class BleSetupRepositoryImpl implements BleSetupRepository {
  final BleSetupDataSource dataSource;

  BleSetupRepositoryImpl(this.dataSource);

  @override
  Future<String> readClientId() async {
    try {
      final result = await dataSource.readClientId();
      return result;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> readMacAddress() async {
    try {
      final result = await dataSource.readMacAddress();
      return result;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> writeClientSecret(String secret) async {
    try {
      await dataSource.writeClientSecret(secret);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> writeWifiSsid(String ssid) async {
    try {
      await dataSource.writeWifiSsid(ssid);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> writeWifiPassword(String password) async {
    try {
      await dataSource.writeWifiPassword(password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> triggerWifiConnect() async {
    try {
      await dataSource.triggerWifiConnect();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> checkSetupCompleted() async {
    try {
      final result = await dataSource.checkSetupCompleted();
      return result;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
