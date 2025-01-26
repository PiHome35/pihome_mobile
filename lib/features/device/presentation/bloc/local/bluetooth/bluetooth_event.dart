sealed class BluetoothEvent {
  const BluetoothEvent();
}

final class CheckBluetoothStatus extends BluetoothEvent {
  const CheckBluetoothStatus();
}

final class RequestBluetoothPermission extends BluetoothEvent {
  const RequestBluetoothPermission();
}

final class EnableBluetooth extends BluetoothEvent {
  const EnableBluetooth();
}
