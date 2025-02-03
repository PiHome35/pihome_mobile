import 'dart:convert';
import 'dart:developer';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_setup_entity.dart';

abstract class BleSetupDataSource {
  void setDevice(BluetoothDevice device);
  Future<String> readClientId();
  Future<String> readMacAddress();
  Future<void> writeClientSecret(String secret);
  Future<void> writeWifiSsid(String ssid);
  Future<void> writeWifiPassword(String password);
  Future<void> triggerWifiConnect();
  Future<bool> checkSetupCompleted();
}

@LazySingleton(as: BleSetupDataSource)
class BleSetupDataSourceImpl implements BleSetupDataSource {
  BluetoothDevice? _device;

  @override
  void setDevice(BluetoothDevice device) {
    _device = device;
  }

  Future<BluetoothCharacteristic> _getCharacteristic(String uuid) async {
    if (_device == null) {
      throw Exception('Device not set');
    }

    final services = await _device!.discoverServices();
    final targetService = services.firstWhere(
      (service) =>
          service.uuid.toString() == BleServiceConfig.targetServiceUuid,
    );

    return targetService.characteristics.firstWhere(
      (char) => char.uuid.toString() == uuid,
    );
  }

  @override
  Future<String> readClientId() async {
    final characteristic =
        await _getCharacteristic(BleServiceConfig.clientIdCharUuid);
    final value = await characteristic.read();
    return utf8.decode(value);
  }

  @override
  Future<String> readMacAddress() async {
    final characteristic =
        await _getCharacteristic(BleServiceConfig.wifiMacCharUuid);
    final value = await characteristic.read();
    return utf8.decode(value);
  }

  @override
  Future<void> writeClientSecret(String secret) async {
    final characteristic =
        await _getCharacteristic(BleServiceConfig.clientSecretCharUuid);
    await characteristic.write(utf8.encode(secret));
    log("writeClientSecret completed");
  }

  @override
  Future<void> writeWifiSsid(String ssid) async {
    final characteristic =
        await _getCharacteristic(BleServiceConfig.wifiSsidCharUuid);
    await characteristic.write(utf8.encode(ssid));
    log("writeWifiSsid completed");
  }

  @override
  Future<void> writeWifiPassword(String password) async {
    final characteristic =
        await _getCharacteristic(BleServiceConfig.wifiPasswordCharUuid);
    await characteristic.write(utf8.encode(password));
    log("writeWifiPassword completed");
  }

  @override
  Future<void> triggerWifiConnect() async {
    final characteristic =
        await _getCharacteristic(BleServiceConfig.wifiConnectTriggerCharUuid);
    await characteristic.write(utf8.encode("connect"));
    log("triggerWifiConnect completed");
  }

  @override
  Future<bool> checkSetupCompleted() async {
    final characteristic =
        await _getCharacteristic(BleServiceConfig.setupCompletedCharUuid);
    final value = await characteristic.read();
    log("checkSetupCompleted completed");
    return utf8.decode(value).toLowerCase() == "true";
  }
}
