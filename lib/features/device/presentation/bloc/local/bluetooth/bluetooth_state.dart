sealed class BluetoothState {
  const BluetoothState();
}

final class BluetoothInitial extends BluetoothState {
  const BluetoothInitial();
}

final class BluetoothLoading extends BluetoothState {
  const BluetoothLoading();
}

final class BluetoothPermissionDenied extends BluetoothState {
  const BluetoothPermissionDenied();
}

final class BluetoothDisabled extends BluetoothState {
  const BluetoothDisabled();
}

final class BluetoothReady extends BluetoothState {
  const BluetoothReady();
}

final class BluetoothError extends BluetoothState {
  final String message;
  const BluetoothError(this.message);
}
