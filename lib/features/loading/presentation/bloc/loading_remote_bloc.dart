import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/domain/usecases/cache_user.dart';
import 'package:mobile_pihome/core/domain/usecases/get_user.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/get_storage_token.dart';
import 'package:mobile_pihome/features/loading/presentation/bloc/loading_remote_event.dart';
import 'package:mobile_pihome/features/loading/presentation/bloc/loading_remote_state.dart';

@injectable
class LoadingRemoteBloc extends Bloc<LoadingRemoteEvent, LoadingRemoteState> {
  final GetUserUseCase _getUserUseCase;
  final GetStorageTokenUseCase _getStorageTokenUseCase;
  final CacheUserUseCase _cacheUserUseCase;

  LoadingRemoteBloc(
    this._getStorageTokenUseCase,
    this._getUserUseCase,
    this._cacheUserUseCase,
  ) : super(const LoadingRemoteInitial()) {
    on<LoadUserData>(_onLoadUserData);
    on<LoadLocalStorage>(_onLoadLocalStorage);
  }

  Future<void> _onLoadUserData(
    LoadUserData event,
    Emitter<LoadingRemoteState> emit,
  ) async {
    try {
      emit(const LoadingRemoteLoading());
      final token = await _getStorageTokenUseCase.execute();

      final dataState = await _getUserUseCase.execute(token);
      log('[LoadingRemoteBloc] dataState: $dataState');
      if (dataState is DataSuccess && dataState.data != null) {
        await _cacheUserUseCase.execute(dataState.data!);
        emit(LoadingRemoteSuccess(dataState.data!));
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
        emit(LoadingRemoteSuccess(dataState.data!));
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
