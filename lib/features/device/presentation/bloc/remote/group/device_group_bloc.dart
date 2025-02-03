import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/get_storage_token.dart';
import 'package:mobile_pihome/features/device/domain/usecases/create_device_group.dart';
import 'package:mobile_pihome/features/device/domain/usecases/delete_device_group.dart';
import 'package:mobile_pihome/features/device/domain/usecases/device_group/add_device_group.dart';
import 'package:mobile_pihome/features/device/domain/usecases/device_group/get_device_group.dart';
import 'package:mobile_pihome/features/device/domain/usecases/device_group/get_device_groups.dart';
import 'package:mobile_pihome/features/device/domain/usecases/device_group/get_device_in_group.dart';
import 'package:mobile_pihome/features/device/domain/usecases/update_device_group.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/remote/group/device_group_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/remote/group/device_group_state.dart';

@injectable
class DeviceGroupBloc extends Bloc<DeviceGroupEvent, DeviceGroupState> {
  final GetDeviceGroupsUseCase _getDeviceGroupsUseCase;
  final CreateDeviceGroupUseCase _createDeviceGroupUseCase;
  final UpdateDeviceGroupUseCase _updateDeviceGroupUseCase;
  final DeleteDeviceGroupUseCase _deleteDeviceGroupUseCase;
  final GetDeviceGroupUseCase _getDeviceGroupUseCase;
  final GetDeviceInGroupUseCase _getDeviceInGroupUseCase;
  final GetStorageTokenUseCase _getStorageTokenUseCase;
  final AddDeviceGroupUseCase _addDeviceGroupUseCase;

  DeviceGroupBloc(
    this._getDeviceGroupsUseCase,
    this._createDeviceGroupUseCase,
    this._updateDeviceGroupUseCase,
    this._deleteDeviceGroupUseCase,
    this._getDeviceGroupUseCase,
    this._getDeviceInGroupUseCase,
    this._getStorageTokenUseCase,
    this._addDeviceGroupUseCase,
  ) : super(const DeviceGroupInitial()) {
    on<GetDeviceGroupsEvent>(_onGetDeviceGroups);
    on<CreateDeviceGroupEvent>(_onCreateDeviceGroup);
    on<UpdateDeviceGroupEvent>(_onUpdateDeviceGroup);
    on<DeleteDeviceGroupEvent>(_onDeleteDeviceGroup);
    on<GetDeviceGroupEvent>(_onGetDeviceGroup);
    on<GetDevicesInGroupEvent>(_onGetDevicesInGroup);
    on<AddDeviceToGroupEvent>(_onAddDeviceToGroup);
  }

  Future<void> _onGetDeviceGroups(
    GetDeviceGroupsEvent event,
    Emitter<DeviceGroupState> emit,
  ) async {
    emit(const DeviceGroupLoading());
    final token = await _getStorageTokenUseCase.execute();
    final result = await _getDeviceGroupsUseCase.execute(token);
    log('result getDeviceGroups: $result');

    if (result is DataSuccess && result.data != null) {
      emit(DeviceGroupsLoaded(result.data!));
    } else if (result is DataFailed) {
      emit(const DeviceGroupError('Failed to load device groups'));
    }
  }

  Future<void> _onCreateDeviceGroup(
    CreateDeviceGroupEvent event,
    Emitter<DeviceGroupState> emit,
  ) async {
    emit(const DeviceGroupLoading());
    final token = await _getStorageTokenUseCase.execute();
    final params = CreateDeviceGroupParams(
      name: event.name,
      token: token,
    );
    try {
      final result = await _createDeviceGroupUseCase.execute(params);
      log('result createDeviceGroup: $result');
      if (result is DataFailed) {
        emit(const DeviceGroupError('Failed to create device group'));
        return;
      }

      final addDeviceParams = AddDeviceGroupParams(
        groupId: result.data!.id,
        deviceIds: event.deviceIds,
        token: token,
      );


      final addDeviceResult =
          await _addDeviceGroupUseCase.execute(addDeviceParams);
      log('result addDeviceGroup: $addDeviceResult');
      if (addDeviceResult is DataFailed) {
        emit(const DeviceGroupError('Failed to add device to group'));
        return;
      }
      if (addDeviceResult is DataSuccess && addDeviceResult.data != null) {
        emit(DeviceGroupLoaded(result.data!));
      } else if (result is DataFailed) {
        emit(const DeviceGroupError('Failed to create device group'));
      }
    } catch (e) {
      log('error addDeviceGroup: $e');
      emit(const DeviceGroupError('Failed to create device group'));
    }
  }

  Future<void> _onUpdateDeviceGroup(
    UpdateDeviceGroupEvent event,
    Emitter<DeviceGroupState> emit,
  ) async {
    emit(const DeviceGroupLoading());
    final token = await _getStorageTokenUseCase.execute();
    final params = UpdateDeviceGroupParams(
      group: event.group,
      token: token,
    );
    final result = await _updateDeviceGroupUseCase.execute(params);

    if (result is DataSuccess && result.data != null) {
      emit(DeviceGroupLoaded(result.data!));
    } else if (result is DataFailed) {
      emit(const DeviceGroupError('Failed to update device group'));
    }
  }

  Future<void> _onDeleteDeviceGroup(
    DeleteDeviceGroupEvent event,
    Emitter<DeviceGroupState> emit,
  ) async {
    emit(const DeviceGroupLoading());
    final token = await _getStorageTokenUseCase.execute();
    final params = DeleteDeviceGroupParams(
      groupId: event.groupId,
      token: token,
    );
    final result = await _deleteDeviceGroupUseCase.execute(params);

    if (result is DataSuccess) {
      emit(const DeviceGroupDeleted());
    } else if (result is DataFailed) {
      emit(const DeviceGroupError('Failed to delete device group'));
    }
  }

  Future<void> _onGetDeviceGroup(
    GetDeviceGroupEvent event,
    Emitter<DeviceGroupState> emit,
  ) async {
    emit(const DeviceGroupLoading());
    final token = await _getStorageTokenUseCase.execute();
    final params = GetDeviceGroupParams(
      groupId: event.groupId,
      token: token,
    );
    final result = await _getDeviceGroupUseCase.execute(params);

    if (result is DataSuccess && result.data != null) {
      emit(DeviceGroupLoaded(result.data!));
    } else if (result is DataFailed) {
      emit(const DeviceGroupError('Failed to load device group'));
    }
  }

  Future<void> _onGetDevicesInGroup(
    GetDevicesInGroupEvent event,
    Emitter<DeviceGroupState> emit,
  ) async {
    emit(const DeviceGroupLoading());
    final token = await _getStorageTokenUseCase.execute();
    final params = GetDeviceInGroupParams(
      groupId: event.groupId,
      token: token,
    );
    final result = await _getDeviceInGroupUseCase.execute(params);

    if (result is DataSuccess && result.data != null) {
      emit(DevicesInGroupLoaded(
        groupId: event.groupId,
        devices: result.data!,
      ));
    } else if (result is DataFailed) {
      emit(const DeviceGroupError('Failed to load devices in group'));
    }
  }

  Future<void> _onAddDeviceToGroup(
    AddDeviceToGroupEvent event,
    Emitter<DeviceGroupState> emit,
  ) async {
    emit(const DeviceGroupLoading());
    final token = await _getStorageTokenUseCase.execute();
    final params = AddDeviceGroupParams(
      groupId: event.groupId,
      deviceIds: event.deviceIds,
      token: token,
    );
    final result = await _addDeviceGroupUseCase.execute(params);
    log('result addDeviceToGroup: $result');
    if (result is DataSuccess) {
      emit(DevicesInGroupLoaded(
        groupId: event.groupId,
        devices: result.data!,
      ));
      add(GetDevicesInGroupEvent(event.groupId));
    } else if (result is DataFailed) {
      emit(const DeviceGroupError('Failed to add device to group'));
    }
  }
}
