import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/get_storage_token.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_status_entify.dart';
import 'package:mobile_pihome/features/device/domain/usecases/group_status/get_device_group_status_usecase.dart';
import 'package:mobile_pihome/features/device/domain/usecases/group_status/set_device_group_muted_usecase.dart';
import 'package:mobile_pihome/features/device/domain/usecases/group_status/subscribe_to_device_group_status_usecase.dart';
import 'device_group_status_event.dart';
import 'device_group_status_state.dart';

@injectable
class DeviceGroupStatusBloc
    extends Bloc<DeviceGroupStatusEvent, DeviceGroupStatusState> {
  StreamSubscription<GraphqlDataState<DeviceGroupStatusEntity>>?
      _statusSubscription;
  final GetDeviceGroupStatusUseCase _getDeviceGroupStatus;
  final GetStorageTokenUseCase _getStorageToken;
  final SetDeviceGroupMutedUseCase _setDeviceGroupMuted;
  final SubscribeToDeviceGroupStatusUseCase _subscribeToDeviceGroupStatus;

  DeviceGroupStatusBloc(
    this._getDeviceGroupStatus,
    this._getStorageToken,
    this._setDeviceGroupMuted,
    this._subscribeToDeviceGroupStatus,
  ) : super(const DeviceGroupStatusInitial()) {
    on<SetGroupMuted>(_onSetGroupMuted);
    on<StartGroupStatusStream>(_onStartGroupStatusStream);
    on<StopGroupStatusStream>(_onStopGroupStatusStream);
    on<NewGroupStatusReceived>(_onNewGroupStatusReceived);
    on<GetDeviceGroupStatus>(_onGetDeviceGroupStatus);
  }

  Future<void> _onGetDeviceGroupStatus(
    GetDeviceGroupStatus event,
    Emitter<DeviceGroupStatusState> emit,
  ) async {
    emit(const DeviceGroupStatusLoading());
    try {
      final token = await _getStorageToken.execute();
      final result = await _getDeviceGroupStatus.execute(
        GetDeviceGroupStatusParams(
          token: token,
          deviceGroupId: event.groupId,
        ),
      );
      if (result is GraphqlDataSuccess<DeviceGroupStatusEntity>) {
        emit(DeviceGroupStatusSuccess(result.data!));
      } else if (result is GraphqlDataFailed) {
        emit(const DeviceGroupStatusError('Failed to get device group status'));
      }
    } catch (e) {
      emit(DeviceGroupStatusError(e.toString()));
    }
  }

  Future<void> _onSetGroupMuted(
    SetGroupMuted event,
    Emitter<DeviceGroupStatusState> emit,
  ) async {
    try {
      final token = await _getStorageToken.execute();
      final result = await _setDeviceGroupMuted.execute(
        SetDeviceGroupMutedParams(
          deviceGroupId: event.groupId,
          isMuted: event.isMuted,
          token: token,
        ),
      );

      if (result is GraphqlDataSuccess<DeviceGroupStatusEntity>) {
        emit(DeviceGroupStatusSuccess(result.data!));
      } else if (result is GraphqlDataFailed) {
        emit(const DeviceGroupStatusError('Failed to set group muted status'));
      }
    } catch (e) {
      emit(DeviceGroupStatusError(e.toString()));
    }
  }

  Future<void> _onStartGroupStatusStream(
    StartGroupStatusStream event,
    Emitter<DeviceGroupStatusState> emit,
  ) async {
    try {
      final token = await _getStorageToken.execute();
      final stream = _subscribeToDeviceGroupStatus.execute(
        SubscribeToDeviceGroupStatusParams(
          token: token,
          deviceGroupId: event.groupId,
        ),
      );

      await _statusSubscription?.cancel();
      _statusSubscription = stream.listen(
        (result) {
          if (result is GraphqlDataSuccess<DeviceGroupStatusEntity>) {
            add(NewGroupStatusReceived(status: result.data!));
          } else if (result is GraphqlDataFailed) {
            add(const StopGroupStatusStream());
          }
        },
        onError: (error) {
          add(const StopGroupStatusStream());
        },
      );
    } catch (e) {
      emit(DeviceGroupStatusError(e.toString()));
    }
  }

  Future<void> _onStopGroupStatusStream(
    StopGroupStatusStream event,
    Emitter<DeviceGroupStatusState> emit,
  ) async {
    await _statusSubscription?.cancel();
    _statusSubscription = null;
  }

  Future<void> _onNewGroupStatusReceived(
    NewGroupStatusReceived event,
    Emitter<DeviceGroupStatusState> emit,
  ) async {
    log('NewGroupStatusReceived: ${event.status}');
    emit(DeviceGroupStatusSuccess(event.status));
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    return super.close();
  }
}
