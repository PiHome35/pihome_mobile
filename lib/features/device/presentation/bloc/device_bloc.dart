import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/usecases/fetch_device.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_state.dart';

@injectable
class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final FetchDeviceUseCase _fetchDeviceUseCase;

  DeviceBloc(this._fetchDeviceUseCase) : super(const DeviceInitial()) {
    on<FetchDevices>(_onFetchDevices);
  }

  Future<void> _onFetchDevices(
    FetchDevices event,
    Emitter<DeviceState> emit,
  ) async {
    try {
      emit(const DeviceLoading());
      final devices = await _fetchDeviceUseCase.execute(null);
      emit(DeviceLoaded(devices));
    } catch (e, stackTrace) {
      log('Failed to fetch devices', error: e, stackTrace: stackTrace);
      emit(DeviceError(e.toString()));
    }
  }
}
