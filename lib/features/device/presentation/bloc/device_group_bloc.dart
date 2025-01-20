import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/device/domain/usecases/create_device_group.dart';
import 'package:mobile_pihome/features/device/domain/usecases/delete_device_group.dart';
import 'package:mobile_pihome/features/device/domain/usecases/get_device_group.dart';
import 'package:mobile_pihome/features/device/domain/usecases/get_device_groups.dart';
import 'package:mobile_pihome/features/device/domain/usecases/update_device_group.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_group_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_group_state.dart';

@injectable
class DeviceGroupBloc extends Bloc<DeviceGroupEvent, DeviceGroupState> {
  final GetDeviceGroupsUseCase _getDeviceGroupsUseCase;
  final CreateDeviceGroupUseCase _createDeviceGroupUseCase;
  final UpdateDeviceGroupUseCase _updateDeviceGroupUseCase;
  final DeleteDeviceGroupUseCase _deleteDeviceGroupUseCase;
  final GetDeviceGroupUseCase _getDeviceGroupUseCase;

  DeviceGroupBloc(
    this._getDeviceGroupsUseCase,
    this._createDeviceGroupUseCase,
    this._updateDeviceGroupUseCase,
    this._deleteDeviceGroupUseCase,
    this._getDeviceGroupUseCase,
  ) : super(const DeviceGroupInitial()) {
    on<GetDeviceGroupsEvent>(_onGetDeviceGroups);
    on<CreateDeviceGroupEvent>(_onCreateDeviceGroup);
    on<UpdateDeviceGroupEvent>(_onUpdateDeviceGroup);
    on<DeleteDeviceGroupEvent>(_onDeleteDeviceGroup);
    on<GetDeviceGroupEvent>(_onGetDeviceGroup);
  }

  Future<void> _onGetDeviceGroups(
    GetDeviceGroupsEvent event,
    Emitter<DeviceGroupState> emit,
  ) async {
    emit(const DeviceGroupLoading());
    final result = await _getDeviceGroupsUseCase.execute();

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
    final result = await _createDeviceGroupUseCase.execute(event.group);

    if (result is DataSuccess && result.data != null) {
      emit(DeviceGroupLoaded(result.data!));
    } else if (result is DataFailed) {
      emit(const DeviceGroupError('Failed to create device group'));
    }
  }

  Future<void> _onUpdateDeviceGroup(
    UpdateDeviceGroupEvent event,
    Emitter<DeviceGroupState> emit,
  ) async {
    emit(const DeviceGroupLoading());
    final result = await _updateDeviceGroupUseCase.execute(event.group);

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
    final result = await _deleteDeviceGroupUseCase.execute(event.groupId);

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
    final result = await _getDeviceGroupUseCase.execute(event.groupId);

    if (result is DataSuccess && result.data != null) {
      emit(DeviceGroupLoaded(result.data!));
    } else if (result is DataFailed) {
      emit(const DeviceGroupError('Failed to load device group'));
    }
  }
}
