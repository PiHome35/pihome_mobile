import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/domain/repositories/bluetooth_repository.dart';
import 'package:permission_handler/permission_handler.dart';

@LazySingleton(as: BluetoothRepository)
class BluetoothRepositoryImpl implements BluetoothRepository {
  @override
  Future<bool> checkBluetoothStatus() async {
    try {
      final isSupported = await FlutterBluePlus.isSupported;
      if (!isSupported) {
        return false;
      }

      final isOn =
          await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
      return isOn;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> requestBluetoothPermission() async {
    try {
      final bluetoothStatus = await Permission.bluetooth.request();
      final bluetoothScanStatus = await Permission.bluetoothScan.request();
      final bluetoothConnectStatus =
          await Permission.bluetoothConnect.request();
      final locationStatus = await Permission.location.request();

      final isGranted = bluetoothStatus.isGranted &&
          bluetoothScanStatus.isGranted &&
          bluetoothConnectStatus.isGranted &&
          locationStatus.isGranted;

      return isGranted;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> enableBluetooth() async {
    try {
      await FlutterBluePlus.turnOn();
      return true;
    } catch (e) {
      return false;
    }
  }
}
