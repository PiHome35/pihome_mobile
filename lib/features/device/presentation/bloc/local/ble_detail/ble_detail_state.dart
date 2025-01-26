import 'package:mobile_pihome/features/device/domain/entities/ble_service_entity.dart';

sealed class BleDetailState {
  const BleDetailState();
}

final class BleDetailInitial extends BleDetailState {
  const BleDetailInitial();
}

final class BleDetailConnecting extends BleDetailState {
  const BleDetailConnecting();
}

final class BleDetailConnected extends BleDetailState {
  final List<BleServiceEntity> services;

  const BleDetailConnected({required this.services});
}

final class BleDetailError extends BleDetailState {
  final String message;

  const BleDetailError({required this.message});
}
