import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/usecases/cache_devices.dart';
import 'package:mobile_pihome/features/device/domain/usecases/get_cache_devices.dart';
import 'package:mobile_pihome/features/device/domain/usecases/update_cached_device.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/device_local_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/device_local_state.dart';

@injectable
class LocalDeviceBloc extends Bloc<LocalDeviceEvent, LocalDeviceState> {
  final CacheDevicesUseCase _cacheDevicesUseCase;
  final GetCachedDevicesUseCase _getCachedDevicesUseCase;
  final UpdateCachedDeviceUseCase _updateCachedDeviceUseCase;

  LocalDeviceBloc(
    this._cacheDevicesUseCase,
    this._getCachedDevicesUseCase,
    this._updateCachedDeviceUseCase,
  ) : super(const LocalDeviceInitial()) {
    on<FetchCachedDevices>(_onFetchCachedDevices);
    on<UpdateCachedDevice>(_onUpdateCachedDevice);
    on<DeleteCachedDevices>(_onDeleteCachedDevices);
    on<CacheDevices>(_onCacheDevices);
  }

  Future<void> _onFetchCachedDevices(
    FetchCachedDevices event,
    Emitter<LocalDeviceState> emit,
  ) async {
    try {
      emit(const LocalDeviceLoading());
      final devices = await _getCachedDevicesUseCase.execute(null);
      emit(LocalDeviceLoaded(devices));
    } catch (e, stackTrace) {
      log('Failed to fetch cached devices', error: e, stackTrace: stackTrace);
      emit(LocalDeviceError(e.toString()));
    }
  }

  Future<void> _onUpdateCachedDevice(
    UpdateCachedDevice event,
    Emitter<LocalDeviceState> emit,
  ) async {
    try {
      emit(const LocalDeviceLoading());
      await _updateCachedDeviceUseCase.execute(event.device);
      emit(LocalDeviceUpdated(event.device));
    } catch (e, stackTrace) {
      log('Failed to update cached device', error: e, stackTrace: stackTrace);
      emit(LocalDeviceError(e.toString()));
    }
  }

  Future<void> _onDeleteCachedDevices(
    DeleteCachedDevices event,
    Emitter<LocalDeviceState> emit,
  ) async {
    try {
      emit(const LocalDeviceLoading());
      // await _deleteCachedDevicesUseCase.execute(event.device);
      emit(const LocalDeviceDeleted());
    } catch (e, stackTrace) {
      log('Failed to delete cached devices', error: e, stackTrace: stackTrace);
      emit(LocalDeviceError(e.toString()));
    }
  }

  Future<void> _onCacheDevices(
    CacheDevices event,
    Emitter<LocalDeviceState> emit,
  ) async {
    try {
      emit(const LocalDeviceLoading());
      await _cacheDevicesUseCase.execute(event.devices);
      emit(LocalDeviceCached(event.devices));
    } catch (e, stackTrace) {
      log('Failed to cache devices', error: e, stackTrace: stackTrace);
      emit(LocalDeviceError(e.toString()));
    }
  }
}
