import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_service_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/ble_detail_repository.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble_detail/ble_detail_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble_detail/ble_detail_state.dart';

@injectable
class BleDetailBloc extends Bloc<BleDetailEvent, BleDetailState> {
  final BleDetailRepository _repository;
  StreamSubscription? _servicesSubscription;

  BleDetailBloc(this._repository) : super(const BleDetailInitial()) {
    on<ConnectToDevice>(_onConnectToDevice);
    on<DisconnectDevice>(_onDisconnectDevice);
    on<ReadCharacteristic>(_onReadCharacteristic);
    on<WriteCharacteristic>(_onWriteCharacteristic);
    on<ToggleNotification>(_onToggleNotification);
  }

  Future<void> _onConnectToDevice(
    ConnectToDevice event,
    Emitter<BleDetailState> emit,
  ) async {
    try {
      emit(const BleDetailConnecting());
      await _repository.connect(event.device);
      await _servicesSubscription?.cancel();
      await emit.forEach<List<BleServiceEntity>>(
        _repository.discoverServices(),
        onData: (services) => BleDetailConnected(services: services),
        onError: (error, stackTrace) {
          log('Error discovering services: $error');
          return BleDetailError(message: error.toString());
        },
      );
    } catch (e) {
      log('Error connecting to device: $e');
      if (!emit.isDone) {
        emit(BleDetailError(message: e.toString()));
      }
    }
  }

  Future<void> _onDisconnectDevice(
    DisconnectDevice event,
    Emitter<BleDetailState> emit,
  ) async {
    try {
      await _repository.disconnect();
      if (!emit.isDone) {
        emit(const BleDetailInitial());
      }
    } catch (e) {
      log('Error disconnecting device: $e');
      if (!emit.isDone) {
        emit(BleDetailError(message: e.toString()));
      }
    }
  }

  Future<void> _onReadCharacteristic(
    ReadCharacteristic event,
    Emitter<BleDetailState> emit,
  ) async {
    if (state is! BleDetailConnected) return;

    try {
      final value = await _repository.readCharacteristic(event.characteristic);
      if (!emit.isDone) {
        final currentState = state as BleDetailConnected;
        final updatedServices = currentState.services.map((service) {
          final characteristics = service.characteristics.map((c) {
            if (c == event.characteristic) {
              return BleCharacteristicEntity(
                uuid: c.uuid,
                canRead: c.canRead,
                canWrite: c.canWrite,
                canNotify: c.canNotify,
                value: value,
              );
            }
            return c;
          }).toList();

          return BleServiceEntity(
            uuid: service.uuid,
            characteristics: characteristics,
          );
        }).toList();

        emit(BleDetailConnected(services: updatedServices));
      }
    } catch (e) {
      log('Error reading characteristic: $e');
      if (!emit.isDone) {
        emit(BleDetailError(message: e.toString()));
      }
    }
  }

  Future<void> _onWriteCharacteristic(
    WriteCharacteristic event,
    Emitter<BleDetailState> emit,
  ) async {
    if (state is! BleDetailConnected) return;

    try {
      await _repository.writeCharacteristic(
        event.characteristic,
        event.value,
      );

      if (!emit.isDone) {
        add(ReadCharacteristic(characteristic: event.characteristic));
      }
    } catch (e) {
      log('Error writing characteristic: $e');
      if (!emit.isDone) {
        emit(BleDetailError(message: e.toString()));
      }
    }
  }

  Future<void> _onToggleNotification(
    ToggleNotification event,
    Emitter<BleDetailState> emit,
  ) async {
    if (state is! BleDetailConnected) return;

    try {
      if (event.enabled) {
        await _repository.enableNotifications(
          event.characteristic,
          (value) {
            if (state is BleDetailConnected && !emit.isDone) {
              final currentState = state as BleDetailConnected;
              final updatedServices = currentState.services.map((service) {
                final characteristics = service.characteristics.map((c) {
                  if (c == event.characteristic) {
                    return BleCharacteristicEntity(
                      uuid: c.uuid,
                      canRead: c.canRead,
                      canWrite: c.canWrite,
                      canNotify: c.canNotify,
                      value: value,
                    );
                  }
                  return c;
                }).toList();

                return BleServiceEntity(
                  uuid: service.uuid,
                  characteristics: characteristics,
                );
              }).toList();

              emit(BleDetailConnected(services: updatedServices));
            }
          },
        );
      } else {
        await _repository.disableNotifications(event.characteristic);
      }
    } catch (e) {
      log('Error toggling notifications: $e');
      if (!emit.isDone) {
        emit(BleDetailError(message: e.toString()));
      }
    }
  }

  @override
  Future<void> close() async {
    await _servicesSubscription?.cancel();
    return super.close();
  }
}
