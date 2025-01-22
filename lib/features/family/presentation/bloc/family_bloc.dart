import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/validations/family_name.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/get_storage_token.dart';
import 'package:mobile_pihome/features/family/domain/usecases/create_family.dart';
import 'package:mobile_pihome/features/family/domain/usecases/create_invite_code.dart';
import 'package:mobile_pihome/features/family/domain/usecases/delete_invite_code.dart';
import 'package:mobile_pihome/features/family/domain/usecases/join_family.dart';
import 'family_event.dart';
import 'family_state.dart';

@injectable
class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  final CreateFamilyUseCase _createFamilyUseCase;
  final GetStorageTokenUseCase _getStorageTokenUseCase;
  final JoinFamilyUseCase _joinFamilyUseCase;

  FamilyBloc(
    this._createFamilyUseCase,
    this._getStorageTokenUseCase,
    this._joinFamilyUseCase,
  ) : super(const FamilyState()) {
    on<FamilyNameChanged>(_onFamilyNameChanged);
    on<CreateFamilySubmitted>(_onCreateFamilySubmitted);
    on<JoinFamilySubmitted>(_onJoinFamilySubmitted);
  }

  void _onFamilyNameChanged(
    FamilyNameChanged event,
    Emitter<FamilyState> emit,
  ) {
    final familyName = FamilyName.dirty(event.name);
    emit(
      state.copyWith(
        familyName: familyName,
        isValid: Formz.validate([familyName]),
      ),
    );
  }

  Future<void> _onCreateFamilySubmitted(
    CreateFamilySubmitted event,
    Emitter<FamilyState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final token = await _getStorageTokenUseCase.execute();
      if (token is DataFailed) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: "Token is empty",
          ),
        );
      }
      final dataState = await _createFamilyUseCase.execute(
        CreateFamilyParams(
          name: state.familyName.value,
          token: token,
        ),
      );

      if (dataState is DataSuccess) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            family: dataState.data,
          ),
        );
      } else if (dataState is DataFailed) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: dataState.exception?.message,
          ),
        );
      }
    } catch (error) {
      log('error: $error');
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Something went wrong',
        ),
      );
    }
  }

  Future<void> _onJoinFamilySubmitted(
    JoinFamilySubmitted event,
    Emitter<FamilyState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final token = await _getStorageTokenUseCase.execute();
      if (token is DataFailed) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: "Token is empty",
          ),
        );
      }
      final dataState = await _joinFamilyUseCase.execute(
        JoinFamilyParams(
          inviteCode: event.inviteCode,
          token: token,
        ),
      );

      if (dataState is DataSuccess) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: dataState.exception?.message,
          ),
        );
      }
    } catch (e) {
      log('[JoinFamilySubmitted] e: $e');
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
