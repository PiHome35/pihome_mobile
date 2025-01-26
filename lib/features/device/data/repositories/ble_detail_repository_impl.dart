import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_service_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/ble_detail_repository.dart';

@LazySingleton(as: BleDetailRepository)
class BleDetailRepositoryImpl implements BleDetailRepository {
  BluetoothDevice? _device;

  @override
  Future<void> connect(BleDeviceEntity device) async {
    try {
      _device = await FlutterBluePlus.scanResults
          .expand((results) => results)
          .firstWhere((result) => result.device.remoteId.toString() == device.id)
          .then((result) => result.device);

      await _device?.connect();
    } catch (e) {
      log('Error connecting to device: $e');
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _device?.disconnect();
    } catch (e) {
      log('Error disconnecting device: $e');
      rethrow;
    }
  }

  @override
  Stream<List<BleServiceEntity>> discoverServices() async* {
    if (_device == null) throw Exception('Device not connected');

    try {
      final services = await _device!.discoverServices();
      yield services.map((service) {
        return BleServiceEntity(
          uuid: service.uuid.toString(),
          characteristics: service.characteristics.map((c) {
            return BleCharacteristicEntity(
              uuid: c.uuid.toString(),
              canRead: c.properties.read,
              canWrite: c.properties.write,
              canNotify: c.properties.notify,
            );
          }).toList(),
        );
      }).toList();
    } catch (e) {
      log('Error discovering services: $e');
      rethrow;
    }
  }

  @override
  Future<String> readCharacteristic(
      BleCharacteristicEntity characteristic) async {
    if (_device == null) throw Exception('Device not connected');

    try {
      final services = await _device!.discoverServices();
      final targetCharacteristic = services
          .expand((s) => s.characteristics)
          .firstWhere((c) => c.uuid.toString() == characteristic.uuid);

      final value = await targetCharacteristic.read();
      return String.fromCharCodes(value);
    } catch (e) {
      log('Error reading characteristic: $e');
      rethrow;
    }
  }

  @override
  Future<void> writeCharacteristic(
    BleCharacteristicEntity characteristic,
    String value,
  ) async {
    if (_device == null) throw Exception('Device not connected');

    try {
      final services = await _device!.discoverServices();
      final targetCharacteristic = services
          .expand((s) => s.characteristics)
          .firstWhere((c) => c.uuid.toString() == characteristic.uuid);

      await targetCharacteristic.write(value.codeUnits);
    } catch (e) {
      log('Error writing characteristic: $e');
      rethrow;
    }
  }

  @override
  Future<void> enableNotifications(
    BleCharacteristicEntity characteristic,
    void Function(String value) onValueChanged,
  ) async {
    if (_device == null) throw Exception('Device not connected');

    try {
      final services = await _device!.discoverServices();
      final targetCharacteristic = services
          .expand((s) => s.characteristics)
          .firstWhere((c) => c.uuid.toString() == characteristic.uuid);

      await targetCharacteristic.setNotifyValue(true);
      targetCharacteristic.onValueReceived.listen((value) {
        onValueChanged(String.fromCharCodes(value));
      });
    } catch (e) {
      log('Error enabling notifications: $e');
      rethrow;
    }
  }

  @override
  Future<void> disableNotifications(
      BleCharacteristicEntity characteristic) async {
    if (_device == null) throw Exception('Device not connected');

    try {
      final services = await _device!.discoverServices();
      final targetCharacteristic = services
          .expand((s) => s.characteristics)
          .firstWhere((c) => c.uuid.toString() == characteristic.uuid);

      await targetCharacteristic.setNotifyValue(false);
    } catch (e) {
      log('Error disabling notifications: $e');
      rethrow;
    }
  }
}
