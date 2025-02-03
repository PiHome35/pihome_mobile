import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleDeviceEntity extends Equatable {
  final String id;
  final String name;
  final int rssi;
  final BluetoothDevice device;

  const BleDeviceEntity({
    required this.id,
    required this.name,
    required this.rssi,
    required this.device,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        rssi,
        device,
      ];
}
