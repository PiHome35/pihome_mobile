import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/get_storage_token.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_status_entity.dart';
import 'package:mobile_pihome/features/device/domain/usecases/device_heartbeat_usecase.dart';
import 'package:mobile_pihome/features/device/domain/usecases/status/get_device_status_usecase.dart';
import 'package:mobile_pihome/features/device/domain/usecases/status/set_device_muted_usecase.dart';
import 'package:mobile_pihome/features/device/domain/usecases/status/set_device_volume_usecase.dart';
import 'package:mobile_pihome/features/device/domain/usecases/status/subscribe_to_device_status_usecase.dart';
import 'device_status_event.dart';
import 'device_status_state.dart';
import 'dart:async';

// @singleton
@injectable
class DeviceStatusBloc extends Bloc<DeviceStatusEvent, DeviceStatusState> {
  StreamSubscription<GraphqlDataState<DeviceStatusEntity>>? _statusSubscription;
  final GetDeviceStatusUseCase _getDeviceStatus;
  final SetDeviceMutedUseCase _setDeviceMuted;
  final SetDeviceVolumeUseCase _setDeviceVolume;
  final SubscribeToDeviceStatusUseCase _subscribeToDeviceStatus;
  final DeviceHeartbeatUseCase _deviceHeartbeat;
  final GetStorageTokenUseCase _getStorageToken;

  DeviceStatusBloc(
    this._setDeviceMuted,
    this._setDeviceVolume,
    this._subscribeToDeviceStatus,
    this._getDeviceStatus,
    this._deviceHeartbeat,
    this._getStorageToken,
  ) : super(const DeviceStatusInitial()) {
    on<GetDeviceStatus>(_onGetStatus);
    on<SetDeviceMuted>(_onSetMuted);
    on<SetDeviceVolume>(_onSetVolume);
    on<StartDeviceStatusStream>(_onStartStatusStream);
    on<StopDeviceStatusStream>(_onStopStatusStream);
    on<DeviceHeartbeat>(_onDeviceHeartbeat);
    on<NewDeviceStatusReceived>(_onNewDeviceStatusReceived);
  }

  Future<void> _onGetStatus(
    GetDeviceStatus event,
    Emitter<DeviceStatusState> emit,
  ) async {
    emit(const DeviceStatusLoading());

    try {
      final token = await _getStorageToken.execute();

      final result = await _getDeviceStatus.execute(
        GetDeviceStatusParams(
          deviceId: event.deviceId,
          token: token,
        ),
      );

      if (result is GraphqlDataSuccess<DeviceStatusEntity>) {
        emit(DeviceStatusSuccess(result.data!));
      } else if (result is GraphqlDataFailed) {
        emit(const DeviceStatusError('Failed to get device status'));
      }
    } catch (e) {
      emit(const DeviceStatusError('Failed to get device status'));
    }
  }

  Future<void> _onSetMuted(
    SetDeviceMuted event,
    Emitter<DeviceStatusState> emit,
  ) async {
    final token = await _getStorageToken.execute();
    final result = await _setDeviceMuted.execute(
      SetDeviceMutedParams(
        deviceId: event.deviceId,
        isMuted: event.isMuted,
        token: token,
      ),
    );

    if (result is GraphqlDataSuccess<DeviceStatusEntity>) {
      emit(DeviceStatusSuccess(result.data!));
    } else if (result is GraphqlDataFailed) {
      emit(const DeviceStatusError('Failed to set device muted'));
    }
  }

  Future<void> _onSetVolume(
    SetDeviceVolume event,
    Emitter<DeviceStatusState> emit,
  ) async {
    final token = await _getStorageToken.execute();
    final result = await _setDeviceVolume.execute(
      SetDeviceVolumeParams(
        deviceId: event.deviceId,
        volumePercent: event.volumePercent,
        token: token,
      ),
    );

    if (result is GraphqlDataSuccess<DeviceStatusEntity>) {
      emit(DeviceStatusSuccess(result.data!));
    } else if (result is GraphqlDataFailed) {
      emit(const DeviceStatusError('Failed to set device volume'));
    }
  }

  Future<void> _onStartStatusStream(
    StartDeviceStatusStream event,
    Emitter<DeviceStatusState> emit,
  ) async {
    try {
      if (_statusSubscription != null) {
        await _statusSubscription?.cancel();
        _statusSubscription = null;
      }
      emit(const DeviceStatusStreamConnecting());
      final token = await _getStorageToken.execute();
      final deviceStatus = await _getDeviceStatus.execute(
        GetDeviceStatusParams(
          deviceId: event.deviceId,
          token: token,
        ),
      );
      if (deviceStatus is GraphqlDataSuccess<DeviceStatusEntity>) {
        emit(DeviceStatusSuccess(deviceStatus.data!));
      }

      _statusSubscription = _subscribeToDeviceStatus
          .execute(
        SubscribeToDeviceStatusParams(
          deviceId: event.deviceId,
          token: token,
        ),
      )
          .listen(
        (result) {
          if (result.data != null) {
            log('new device status received: ${result.data}');
            add(NewDeviceStatusReceived(status: result.data!));
          }
        },
        onError: (error) {
          log('stream Device Status error: $error');
          emit(DeviceStatusStreamDisconnected(error.toString()));
        },
        onDone: () {
          log('stream Device Status done');
          add(const StopDeviceStatusStream());
        },
      );
    } catch (e, stackTrace) {
      log('stream Device Status error: $e', error: e, stackTrace: stackTrace);
      emit(DeviceStatusStreamDisconnected(e.toString()));
    }
  }

  Future<void> _onNewDeviceStatusReceived(
    NewDeviceStatusReceived event,
    Emitter<DeviceStatusState> emit,
  ) async {
    final currentState = state;
    if (currentState is DeviceStatusSuccess) {
      emit(DeviceStatusSuccess(event.status));
    }
  }

  Future<void> _onStopStatusStream(
    StopDeviceStatusStream event,
    Emitter<DeviceStatusState> emit,
  ) async {
    await _statusSubscription?.cancel();
    log('status subscription cancelled');
    _statusSubscription = null;
  }

  Future<void> _onDeviceHeartbeat(
    DeviceHeartbeat event,
    Emitter<DeviceStatusState> emit,
  ) async {
    try {
      final token = await _getStorageToken.execute();

      final result = await _deviceHeartbeat.execute(
        DeviceHeartbeatParams(
          deviceId: event.deviceId,
          token: token,
        ),
      );

      if (result is GraphqlDataSuccess<DeviceStatusEntity>) {
        emit(DeviceStatusSuccess(result.data!));
      } else if (result is GraphqlDataFailed) {
        emit(const DeviceStatusError('Failed to send device heartbeat'));
      }
    } catch (e) {
      emit(const DeviceStatusError('Failed to send device heartbeat'));
    }
  }

  Timer? _heartbeatTimer;

  Future<void> startHeartbeat(String deviceId) async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (state is! DeviceStatusStreamDisconnected) {
        add(DeviceHeartbeat(deviceId: deviceId));
      }
    });
  }

  void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  @override
  Future<void> close() {
    stopHeartbeat();
    _statusSubscription = null;
    return super.close();
  }
}
