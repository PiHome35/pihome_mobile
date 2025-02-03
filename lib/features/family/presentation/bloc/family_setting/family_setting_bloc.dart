import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/get_storage_token.dart';
import 'package:mobile_pihome/features/family/domain/usecases/create_invite_code.dart';
import 'package:mobile_pihome/features/family/domain/usecases/delete_invite_code.dart';
import 'package:mobile_pihome/features/family/domain/usecases/get_family_detail.dart';
import 'package:mobile_pihome/features/family/domain/usecases/list_user_family.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_state.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_event.dart';

@injectable
class FamilySettingBloc extends Bloc<FamilySettingEvent, FamilySettingState> {
  final CreateInviteCodeUseCase _createInviteCodeUseCase;
  final DeleteInviteCodeUseCase _deleteInviteCodeUseCase;
  final GetStorageTokenUseCase _getStorageTokenUseCase;
  final ListUserFamilyUseCase _listUserFamilyUseCase;
  final GetFamilyDetailUseCase _getFamilyDetailUseCase;

  FamilySettingBloc(
    this._createInviteCodeUseCase,
    this._deleteInviteCodeUseCase,
    this._getStorageTokenUseCase,
    this._listUserFamilyUseCase,
    this._getFamilyDetailUseCase,
  ) : super(const FamilySettingStateInitial()) {
    on<FamilyInviteCodePressed>(_onFamilyInviteCodePressed);
    on<FetchFamilySettingDetail>(_onFetchFamilySettingDetail);
    on<FamilyDeleteInviteCodePressed>(_onFamilyDeleteInviteCodePressed);
    on<FamilySettingPressed>(_onFamilySettingPressed);
  }

  Future<void> _onFamilySettingPressed(
    FamilySettingEvent event,
    Emitter<FamilySettingState> emit,
  ) async {
    try {
      emit(const FamilySettingStateLoading());

      final token = await _getStorageTokenUseCase.execute();
      if (token.isEmpty) {
        emit(const FamilySettingStateFailure(errorMessage: 'Token is empty'));
        return;
      }

      final result = await _getFamilyDetailUseCase.execute(token);
      final resultUsers = await _listUserFamilyUseCase
          .execute(ListUserFamilyParams(token: token));

      if (result is DataSuccess && resultUsers is DataSuccess) {
        emit(FamilySettingStateSuccess(
            users: resultUsers.data, family: result.data));
      } else {
        emit(const FamilySettingStateFailure(
            errorMessage: 'Failed to load family settings'));
      }
    } catch (e) {
      log('[FamilySettingBloc] Error loading family settings: $e');
      emit(FamilySettingStateFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchFamilySettingDetail(
    FamilySettingEvent event,
    Emitter<FamilySettingState> emit,
  ) async {
    try {
      emit(const FamilySettingStateLoading());

      final token = await _getStorageTokenUseCase.execute();
      if (token.isEmpty) {
        emit(const FamilySettingStateFailure(errorMessage: 'Token is empty'));
        return;
      }

      final result = await _listUserFamilyUseCase
          .execute(ListUserFamilyParams(token: token));
      log('result list user family: $result');
      final resultFamily = await _getFamilyDetailUseCase.execute(token);
      log('result family detail: $resultFamily');
      if (result is DataSuccess && resultFamily is DataSuccess) {
        emit(FamilySettingStateSuccess(
            users: result.data, family: resultFamily.data));
      } else {
        emit(const FamilySettingStateFailure(
            errorMessage: 'Failed to load family details'));
      }
    } catch (e) {
      log('[FamilySettingBloc] Error loading family details: $e');
      emit(FamilySettingStateFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onFamilyInviteCodePressed(
    FamilySettingEvent event,
    Emitter<FamilySettingState> emit,
  ) async {
    try {
      // Keep current family and users data
      final currentFamily = state.family;
      final currentUsers = state.users;

      emit(FamilyInviteCodeStateLoading(
        family: currentFamily,
        users: currentUsers,
      ));

      final token = await _getStorageTokenUseCase.execute();
      if (token.isEmpty) {
        emit(FamilyInviteCodeStateFailure(
          errorMessage: 'Token is empty',
          family: currentFamily,
          users: currentUsers,
        ));
        return;
      }

      final createResult = await _createInviteCodeUseCase
          .execute(CreateInviteCodeParams(token: token));

      if (createResult is DataSuccess) {
        emit(FamilyInviteCodeStateSuccess(
          inviteCode: createResult.data,
          family: currentFamily,
          users: currentUsers,
        ));
      } else {
        emit(FamilyInviteCodeStateFailure(
          errorMessage: 'Failed to create invite code',
          family: currentFamily,
          users: currentUsers,
        ));
      }
    } catch (e) {
      log('[FamilySettingBloc] Error generating invite code: $e');
      emit(FamilyInviteCodeStateFailure(
        errorMessage: e.toString(),
        family: state.family,
        users: state.users,
      ));
    }
  }

  Future<void> _onFamilyDeleteInviteCodePressed(
    FamilyDeleteInviteCodePressed event,
    Emitter<FamilySettingState> emit,
  ) async {
    try {
      emit(const FamilySettingStateLoading());

      final token = await _getStorageTokenUseCase.execute();
      if (token.isEmpty) {
        emit(const FamilySettingStateFailure(errorMessage: 'Token is empty'));
        return;
      }

      final result = await _deleteInviteCodeUseCase
          .execute(DeleteInviteCodeParams(token: token));

      if (result is DataSuccess) {
        emit(const FamilyDeleteInviteCodeStateSuccess());
      } else {
        emit(const FamilyInviteCodeStateFailure(
            errorMessage: 'Failed to delete invite code'));
      }
    } catch (e) {
      log('[FamilySettingBloc] Error deleting invite code: $e');
      emit(FamilyInviteCodeStateFailure(errorMessage: e.toString()));
    }
  }
}
