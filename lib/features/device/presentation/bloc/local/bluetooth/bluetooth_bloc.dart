import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/domain/repositories/bluetooth_repository.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/bluetooth/bluetooth_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/bluetooth/bluetooth_state.dart';

@injectable
class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  final BluetoothRepository _repository;

  BluetoothBloc(this._repository) : super(const BluetoothInitial()) {
    on<CheckBluetoothStatus>(_onCheckBluetoothStatus);
    on<RequestBluetoothPermission>(_onRequestBluetoothPermission);
    on<EnableBluetooth>(_onEnableBluetooth);
  }

  Future<void> _onCheckBluetoothStatus(
    CheckBluetoothStatus event,
    Emitter<BluetoothState> emit,
  ) async {
    emit(const BluetoothLoading());

    final result = await _repository.checkBluetoothStatus();

    if (result) {
      emit(const BluetoothReady());
    } else {
      emit(const BluetoothDisabled());
    }
  }

  Future<void> _onRequestBluetoothPermission(
    RequestBluetoothPermission event,
    Emitter<BluetoothState> emit,
  ) async {
    emit(const BluetoothLoading());

    final result = await _repository.requestBluetoothPermission();

    if (result) {
      add(const CheckBluetoothStatus());
    } else {
      emit(const BluetoothPermissionDenied());
    }
  }

  Future<void> _onEnableBluetooth(
    EnableBluetooth event,
    Emitter<BluetoothState> emit,
  ) async {
    emit(const BluetoothLoading());
    final result = await _repository.enableBluetooth();
    if (result) {
      add(const CheckBluetoothStatus());
    } else {
      emit(const BluetoothError('Failed to enable Bluetooth'));
    }
  }
}
