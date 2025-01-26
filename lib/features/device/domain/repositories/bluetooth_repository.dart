
abstract class BluetoothRepository {
  Future<bool> checkBluetoothStatus();
  Future<bool> requestBluetoothPermission();
  Future<bool> enableBluetooth();
}

