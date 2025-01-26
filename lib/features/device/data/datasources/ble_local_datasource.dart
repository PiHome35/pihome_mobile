import 'dart:developer';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BleLocalDataSource {
  Stream<List<BluetoothDevice>> scanDevices();
  Future<void> stopScan();
}

class BleLocalDataSourceImpl implements BleLocalDataSource {
  @override
  Stream<List<BluetoothDevice>> scanDevices() async* {
    try {
      // Start scanning
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
        androidUsesFineLocation: false,
      );

      // Listen to scan results
      await for (final results in FlutterBluePlus.scanResults) {
        log('Scan results: ${results.length} devices');
        final filteredDevices = results
            .where((result) =>
                result.device.platformName.isNotEmpty &&
                result.device.platformName != 'Unknown')
            .map((result) => result.device)
            .toList();

        log('Filtered devices: ${filteredDevices.length}');
        yield filteredDevices;
      }
    } catch (e) {
      log('Error scanning: $e');
      rethrow;
    }
  }

  @override
  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      log('Error stopping scan: $e');
      rethrow;
    }
  }
}
