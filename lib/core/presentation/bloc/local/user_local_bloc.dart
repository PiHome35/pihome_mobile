import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/domain/usecases/get_cached_user.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_event.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';

@injectable
class UserLocalBloc extends Bloc<UserLocalEvent, UserLocalState> {
  final GetCachedUserUseCase _getCachedUserUseCase;

  UserLocalBloc(this._getCachedUserUseCase) : super(const UserLocalInitial()) {
    on<GetCachedUserEvent>(_onGetCachedUser);
  }

  Future<void> _onGetCachedUser(
    GetCachedUserEvent event,
    Emitter<UserLocalState> emit,
  ) async {
    try {
      emit(const UserLocalLoading());
      final user = await _getCachedUserUseCase.execute(const NoParams());
      log('[getLocalUser] user: ${user.toEntity()}');
      emit(UserLocalLoaded(user.toEntity()));
    } catch (e) {
      emit(UserLocalError(e.toString()));
    }
  }
}
