import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';

sealed class BleScanEvent {
  const BleScanEvent();
}

final class StartScan extends BleScanEvent {
  const StartScan();
}

final class StopScan extends BleScanEvent {
  const StopScan();
}

final class DevicesUpdated extends BleScanEvent {
  final List<dynamic> devices;

  const DevicesUpdated({required this.devices});
}

final class ScanComplete extends BleScanEvent {
  const ScanComplete();
}
