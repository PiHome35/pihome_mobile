import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/ble_scan_repository.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble/ble_scan_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble/ble_scan_state.dart';

@injectable
class BleScanBloc extends Bloc<BleScanEvent, BleScanState> {
  final BleScanRepository _repository;
  StreamSubscription? _scanSubscription;
  Timer? _autoStopTimer;

  BleScanBloc(this._repository) : super(const BleScanInitial()) {
    on<StartScan>(_onStartScan);
    on<StopScan>(_onStopScan);
    on<DevicesUpdated>(_onDevicesUpdated);
  }

  Future<void> _onStartScan(StartScan event, Emitter<BleScanState> emit) async {
    emit(const BleScanInProgress(devices: []));

    try {
      _scanSubscription?.cancel();
      _autoStopTimer?.cancel();

      _scanSubscription = _repository.scanForDevices().listen(
        (devices) {
          log('devices on start scan: $devices');
          add(DevicesUpdated(devices: devices));
        },
        onError: (error) {
          add(const StopScan());
          emit(BleScanError(message: error.toString()));
        },
      );

      // Auto stop after 10 seconds
      _autoStopTimer = Timer(const Duration(seconds: 10), () {
        if (!isClosed) {
          add(const StopScan());
        }
      });
    } catch (e) {
      emit(BleScanError(message: e.toString()));
    }
  }

  Future<void> _onStopScan(StopScan event, Emitter<BleScanState> emit) async {
    try {
      _autoStopTimer?.cancel();
      await _repository.stopScan();
      if (state is BleScanInProgress) {
        final devices = (state as BleScanInProgress).devices;
        log('devices on stop scan: $devices');
        emit(BleScanComplete(devices: devices));
      }
    } catch (e) {
      emit(BleScanError(message: e.toString()));
    }
  }

  void _onDevicesUpdated(DevicesUpdated event, Emitter<BleScanState> emit) {
    if (state is BleScanInProgress) {
      emit(BleScanInProgress(devices: event.devices.cast()));
    }
  }

  @override
  Future<void> close() {
    _autoStopTimer?.cancel();
    _scanSubscription?.cancel();
    return super.close();
  }
}
