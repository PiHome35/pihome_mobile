import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/domain/usecases/get_cached_user.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/get_storage_token.dart';
import 'package:mobile_pihome/features/loading/domain/usecases/cache_setting.dart';
import 'package:mobile_pihome/features/setting/domain/usecases/create_spotify_connection.dart';
import 'package:mobile_pihome/features/setting/domain/usecases/get_cache_setting.dart';
import 'package:mobile_pihome/features/setting/domain/usecases/get_chat_ai_models.dart';
import 'package:mobile_pihome/features/setting/domain/usecases/update_setting.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_event.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_state.dart';

@injectable
class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final GetStorageTokenUseCase _getStorageTokenUseCase;
  final CreateSpotifyConnectionUseCase _createSpotifyConnectionUseCase;
  final GetCachedUserUseCase _getCachedUserUseCase;
  final GetCachedSettingUseCase _getCachedSettingUseCase;
  final GetChatAiModelsUseCase _getChatAiModelsUseCase;
  final UpdateSettingUseCase _updateSettingUseCase;
  // final UpdateCachedSettingUseCase _updateCachedSettingUseCase;
  final CacheSettingUseCase _cacheSettingUseCase;

  SettingBloc(
    this._getStorageTokenUseCase,
    this._createSpotifyConnectionUseCase,
    this._getCachedUserUseCase,
    this._getCachedSettingUseCase,
    this._getChatAiModelsUseCase,
    this._updateSettingUseCase,
    this._cacheSettingUseCase,
  ) : super(const SettingInitial()) {
    on<GetSettingEvent>(_onGetSetting);
    on<UpdateSettingEvent>(_onUpdateSetting);
    on<CreateSpotifyConnectEvent>(_onCreateSpotifyConnect);
    on<LogoutSpotifyConnectEvent>(_onLogoutSpotifyConnect);
    on<GetChatAiModelsEvent>(_onGetChatAiModels);
    on<UpdateSelectedAiModelEvent>(_onUpdateSelectedAiModel);
  }

  Future<void> _onGetSetting(
      GetSettingEvent event, Emitter<SettingState> emit) async {
    log('[SettingBloc] _onGetSetting');
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

  Future<void> _onGetChatAiModels(
      GetChatAiModelsEvent event, Emitter<SettingState> emit) async {
    try {
      final token = await _getStorageTokenUseCase.execute();
      final models = await _getChatAiModelsUseCase.execute(token);

      if (state is SettingLoaded) {
        final currentState = state as SettingLoaded;
        emit(currentState.copyWith(chatModels: models));
      }
    } catch (e) {
      log('[SettingBloc] _onGetChatAiModels error: $e');
      emit(SettingError(e.toString()));
    }
  }

  Future<void> _onUpdateSetting(
      UpdateSettingEvent event, Emitter<SettingState> emit) async {
    // final currentState = state;
    add(const GetSettingEvent());
  }

  Future<void> _onUpdateSelectedAiModel(
      UpdateSelectedAiModelEvent event, Emitter<SettingState> emit) async {
    final currentState = state;
    if (currentState is SettingLoaded) {
      final updatedSetting = currentState.setting.copyWith(
        selectedLLMModel: event.modelId,
      );

      final token = await _getStorageTokenUseCase.execute();

      final params = UpdateSettingParams(
        token: token,
        chatModelKey: event.modelKey,
      );
      final result = await _updateSettingUseCase.execute(params);
      log('result updateSetting useCase: ${result.toString()}');
      if (result is DataSuccess) {
        await _cacheSettingUseCase.execute(updatedSetting);
        emit(SettingLoaded(
          updatedSetting,
          isModelUpdateSuccess: true,
        ));
      } else if (result is DataFailed) {
        emit(const SettingError('Failed to update setting'));
      }

      add(UpdateSettingEvent(updatedSetting));
    }
  }
}
