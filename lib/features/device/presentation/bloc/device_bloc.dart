import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/get_storage_token.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/usecases/device/local/cache_devices.dart';
import 'package:mobile_pihome/features/device/domain/usecases/device/remote/get_device.dart';
import 'package:mobile_pihome/features/device/domain/usecases/device_group/get_device_groups.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_state.dart';

@injectable
class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final GetDevicesUseCase _getDevicesUseCase;
  final GetStorageTokenUseCase _getStorageTokenUseCase;
  final CacheDevicesUseCase _cacheDevicesUseCase;
  final GetDeviceGroupsUseCase _getDeviceGroupsUseCase;

  DeviceBloc(
    this._getDevicesUseCase,
    this._getStorageTokenUseCase,
    this._cacheDevicesUseCase,
    this._getDeviceGroupsUseCase,
  ) : super(const DeviceInitial()) {
    on<GetDevices>(_onGetDevices);
  }

  Future<void> _onGetDevices(
    GetDevices event,
    Emitter<DeviceState> emit,
  ) async {
    try {
      emit(const DeviceLoading());

      final token = await _getStorageTokenUseCase.execute();
      if (token.isEmpty) {
        emit(const DeviceError('No token found'));
        return;
      }

      final dataStateDevices = await _getDevicesUseCase.execute(token);
      if (dataStateDevices is DataFailed) {
        emit(const DeviceError('Failed to fetch devices'));
        return;
      }

      final devices = dataStateDevices.data!;
      await _cacheDevicesUseCase.execute(devices);
      final dataStateDeviceGroups = await _getDeviceGroupsUseCase.execute(token);
      if (dataStateDeviceGroups is DataFailed) {
        emit(const DeviceError('Failed to fetch device groups'));
        return;
      }

      final resultDevices = _getDevices(devices);

      emit(DeviceLoaded(
        devices: resultDevices.ungroupedDevices,
        deviceGroups: dataStateDeviceGroups.data!,
      ));
    } catch (e, stackTrace) {
      log('Failed to fetch devices', error: e, stackTrace: stackTrace);
      emit(const DeviceError('Failed to fetch devices'));
    }
  }
  

  

  ({List<DeviceEntity> ungroupedDevices, List<DeviceEntity> groupedDevices})
      _getDevices(List<DeviceEntity> devices) {
    final List<DeviceEntity> ungroupedDevices = [];
    final List<DeviceEntity> groupedDevices = [];
    for (final device in devices) {
      if (device.deviceGroupId == null) {
        ungroupedDevices.add(device);
      } else {
        groupedDevices.add(device);
      }
    }
    return (
      ungroupedDevices: ungroupedDevices,
      groupedDevices: groupedDevices,
    );
  }
}
