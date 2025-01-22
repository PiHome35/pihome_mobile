import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/domain/usecases/cache_user.dart';
import 'package:mobile_pihome/core/domain/usecases/get_user.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/get_storage_token.dart';
import 'package:mobile_pihome/features/family/domain/entities/family_entity.dart';
import 'package:mobile_pihome/features/family/domain/usecases/get_family_detail.dart';
import 'package:mobile_pihome/features/loading/domain/usecases/cache_setting.dart';
import 'package:mobile_pihome/features/loading/domain/usecases/get_spotify_connect.dart';
import 'package:mobile_pihome/features/loading/presentation/bloc/loading_remote_event.dart';
import 'package:mobile_pihome/features/loading/presentation/bloc/loading_remote_state.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/domain/entities/spotify_connection_entity.dart';

@injectable
class LoadingRemoteBloc extends Bloc<LoadingRemoteEvent, LoadingRemoteState> {
  final GetUserUseCase _getUserUseCase;
  final GetStorageTokenUseCase _getStorageTokenUseCase;
  final CacheUserUseCase _cacheUserUseCase;
  final GetSpotifyConnectUseCase _getSpotifyConnectUseCase;
  final GetFamilyDetailUseCase _getFamilyDetailUseCase;
  final CacheSettingUseCase _cacheSettingUseCase;

  LoadingRemoteBloc(
    this._getStorageTokenUseCase,
    this._getUserUseCase,
    this._cacheUserUseCase,
    this._getSpotifyConnectUseCase,
    this._getFamilyDetailUseCase,
    this._cacheSettingUseCase,
  ) : super(const LoadingRemoteInitial()) {
    on<LoadUserData>(_onLoadUserData);
    on<LoadLocalStorage>(_onLoadLocalStorage);
    on<LoadSpotifyConnect>(_onLoadSpotifyConnect);
    on<LoadSetting>(_onLoadSetting);
    on<LoadFamily>(_onLoadFamilyDetail);
  }

  Future<void> _onLoadSetting(
    LoadSetting event,
    Emitter<LoadingRemoteState> emit,
  ) async {
    try {
      // 1. Get token
      final token = await _getStorageTokenUseCase.execute();
      if (token.isEmpty) {
        emit(const LoadingRemoteError('Token is empty'));
        return;
      }

      // final dataStateUser = await _getUserUseCase.execute(token);
      final dataStateUser = await _getUserUseCase.execute(token);
      log('dataStateUser: $dataStateUser');
      if (dataStateUser is DataFailed) {
        emit(LoadingRemoteError(
            dataStateUser.exception?.message ?? 'Failed to get user details'));
        return;
      }

      // 2. Get Family Detail
      FamilyEntity? familyDetailData;
      SpotifyConnectionEntity? spotifyConnectionData;
      if (dataStateUser is DataSuccess && dataStateUser.data?.familyId != null) {
        final dataStateFamily = await _getFamilyDetailUseCase.execute(token);
        if (dataStateFamily is DataFailed) {
          emit(LoadingRemoteError(dataStateFamily.exception?.message ??
              'Failed to get family details'));
          return;
        }
        log('dataStateFamily: $dataStateFamily');
        familyDetailData = (dataStateFamily as DataSuccess<FamilyEntity?>).data;
        log('familyDetailData: $familyDetailData');
        final dataStateSpotify = await _getSpotifyConnectUseCase.execute(
          GetSpotifyConnectParams(accessToken: token),
        );

        spotifyConnectionData =
            dataStateSpotify is DataSuccess ? dataStateSpotify.data : null;
        log('spotifyConnectionData: $spotifyConnectionData');
      }

      // 3. Get Spotify Connection only if family detail is successful

      // 4. Create Setting Entity with combined data
      final settingData = SettingEntity(
        userEmail: '',
        selectedLLMModel: familyDetailData?.chatModelId ?? '',
        isSpotifyConnected: spotifyConnectionData != null,
        familyName: familyDetailData?.name ?? '',
      );
      log('settingData: $settingData');
      // 5. Cache setting data
      await _cacheSettingUseCase.execute(settingData);

      // 6. Emit success state with setting data
      emit(LoadingRemoteSettingSuccess(settingData));
    } catch (e) {
      log('Error in _onLoadSetting', error: e);
      emit(LoadingRemoteError(e.toString()));
    }
  }

  Future<void> _onLoadSpotifyConnect(
    LoadSpotifyConnect event,
    Emitter<LoadingRemoteState> emit,
  ) async {
    final token = await _getStorageTokenUseCase.execute();
    if (token.isEmpty) {
      emit(const LoadingRemoteError('Token is empty'));
    }
    final dataState = await _getSpotifyConnectUseCase.execute(
      GetSpotifyConnectParams(
        accessToken: token,
      ),
    );
    log('[LoadingRemoteBloc] spotify dataState: ${dataState.toString()}');
    log('[LoadingRemoteBloc] spotify dataState.data: ${dataState.data.toString()}');
    if (dataState is DataSuccess && dataState.data != null) {
      emit(LoadingRemoteSpotifySuccess(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(LoadingRemoteError(dataState.exception?.message ?? 'Unknown error'));
    } else {
      emit(const LoadingRemoteSpotifyNotFound());
    }
  }

  Future<void> _onLoadFamilyDetail(
    LoadFamily event,
    Emitter<LoadingRemoteState> emit,
  ) async {
    final token = await _getStorageTokenUseCase.execute();
    final dataState = await _getFamilyDetailUseCase.execute(token);
    if (dataState is DataSuccess) {
      emit(LoadingRemoteFamilySuccess(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(LoadingRemoteError(dataState.exception?.message ?? 'Unknown error'));
    }
  }

  Future<void> _onLoadUserData(
    LoadUserData event,
    Emitter<LoadingRemoteState> emit,
  ) async {
    log('LoadingUserData');
    try {
      emit(const LoadingRemoteLoading());
      final token = await _getStorageTokenUseCase.execute();

      final dataState = await _getUserUseCase.execute(token);
      log('[LoadingRemoteBloc] user dataState: ${dataState.toString()}');
      if (dataState is DataSuccess && dataState.data != null) {
        await _cacheUserUseCase.execute(dataState.data!);
        emit(LoadingRemoteUserSuccess(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(
          LoadingRemoteError(
            dataState.exception?.message ?? 'Unknown error',
          ),
        );
      }
    } catch (e, stackTrace) {
      log('Failed to load user data', error: e, stackTrace: stackTrace);
      emit(LoadingRemoteError(e.toString()));
    }
  }

  Future<void> _onLoadLocalStorage(
    LoadLocalStorage event,
    Emitter<LoadingRemoteState> emit,
  ) async {
    try {
      emit(const LoadingRemoteLoading());
      final token = await _getStorageTokenUseCase.execute();

      final dataState = await _getUserUseCase.execute(token);
      if (dataState is DataSuccess) {
        emit(LoadingRemoteUserSuccess(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(LoadingRemoteError(
            dataState.exception?.message ?? 'Unknown error'));
      }
    } catch (e, stackTrace) {
      log('Failed to load local storage', error: e, stackTrace: stackTrace);
      emit(LoadingRemoteError(e.toString()));
    }
  }
}
