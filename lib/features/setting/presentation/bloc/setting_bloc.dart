import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/domain/usecases/get_cached_user.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/get_storage_token.dart';
import 'package:mobile_pihome/features/setting/domain/usecases/create_spotify_connection.dart';
import 'package:mobile_pihome/features/setting/domain/usecases/get_cache_setting.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_event.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_state.dart';

@injectable
class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final GetStorageTokenUseCase _getStorageTokenUseCase;
  final CreateSpotifyConnectionUseCase _createSpotifyConnectionUseCase;
  final GetCachedUserUseCase _getCachedUserUseCase;
  final GetCachedSettingUseCase _getCachedSettingUseCase;
  SettingBloc(
    this._getStorageTokenUseCase,
    this._createSpotifyConnectionUseCase,
    this._getCachedUserUseCase,
    this._getCachedSettingUseCase,
  ) : super(const SettingInitial()) {
    on<GetSettingEvent>(_onGetSetting);
    // on<UpdateSettingEvent>(_onUpdateSetting);
    on<CreateSpotifyConnectEvent>(_onCreateSpotifyConnect);
    on<LogoutSpotifyConnectEvent>(_onLogoutSpotifyConnect);
  }

  Future<void> _onGetSetting(
      GetSettingEvent event, Emitter<SettingState> emit) async {
    emit(const SettingLoading());
    final settingLocal =
        await _getCachedSettingUseCase.execute(const NoParams());
    emit(SettingLoaded(settingLocal));
  }

  Future<void> _onCreateSpotifyConnect(
      CreateSpotifyConnectEvent event, Emitter<SettingState> emit) async {
    final currentState = state;

    final token = await _getStorageTokenUseCase.execute();
    if (token.isEmpty) {
      emit(const SettingError('Token not found'));
      return;
    }
    
    final params = CreateSpotifyConnectionParams(
      accessToken: token,
    );
    if (currentState is SettingLoaded) {
      final result = await _createSpotifyConnectionUseCase.execute(params);
      log('result createSpotifyConnection useCase: ${result.toString()}');
      if (result is DataSuccess && result.data != null) {
        final setting = currentState.setting.copyWith(
          isSpotifyConnected: true,
        );
        emit(SettingLoaded(setting));
      } else if (result is DataFailed) {
        emit(SettingError(result.exception?.message ?? 'Unknown error'));
      }
    }
  }

  Future<void> _onLogoutSpotifyConnect(
      LogoutSpotifyConnectEvent event, Emitter<SettingState> emit) async {
    final currentState = state;
    if (currentState is SettingLoaded) {
      final setting = currentState.setting.copyWith(
        isSpotifyConnected: false,
      );
      emit(SettingLoaded(setting));
    }
  }


}
