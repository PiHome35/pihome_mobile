import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/validations/confirm_password.dart';
import 'package:mobile_pihome/core/validations/email.dart';
import 'package:mobile_pihome/core/validations/full_name.dart';
import 'package:mobile_pihome/core/validations/password.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/check_auth.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/login.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/storage_token.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/register.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final CheckAuthUseCase _checkAuthUseCase;
  final StorageTokenUseCase _storageTokenUseCase;
  final RegisterUseCase _register;

  AuthBloc(
    this._loginUseCase,
    this._checkAuthUseCase,
    this._storageTokenUseCase,
    this._register,
  ) : super(const AuthState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<FullNameChanged>(_onFullNameChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<CheckAuth>(_onCheckAuth);
    on<RegisterRequested>(_onRegisterRequested);
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    log('transition: $transition');
  }

  void _onEmailChanged(
    EmailChanged event,
    Emitter<AuthState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([
          email,
          state.password,
          state.confirmPassword,
          state.fullName,
        ]),
      ),
    );
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    final password = Password.dirty(event.password);
    final confirmPassword = ConfirmPassword.dirty(
      password: event.password,
      value: state.confirmPassword.value,
    );
    emit(
      state.copyWith(
        password: password,
        confirmPassword: confirmPassword,
        isValid: Formz.validate([
          state.email,
          password,
          confirmPassword,
          state.fullName,
        ]),
      ),
    );
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    final confirmPassword = ConfirmPassword.dirty(
      password: state.password.value,
      value: event.confirmPassword,
    );
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        isValid: Formz.validate([
          state.email,
          state.password,
          confirmPassword,
          state.fullName,
        ]),
      ),
    );
  }

  void _onFullNameChanged(
    FullNameChanged event,
    Emitter<AuthState> emit,
  ) {
    final fullName = FullName.dirty(event.fullName);
    emit(
      state.copyWith(
        fullName: fullName,
        isValid: Formz.validate([
          state.email,
          state.password,
          state.confirmPassword,
          fullName,
        ]),
      ),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final dataState = await _loginUseCase.execute(
        LoginParams(
          email: state.email.value,
          password: state.password.value,
        ),
      );

      if (dataState is DataSuccess) {
        await _storageTokenUseCase.execute(dataState.data!.accessToken);
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else if (dataState is DataFailed) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: dataState.exception?.message,
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onCheckAuth(
    CheckAuth event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    await Future.delayed(const Duration(seconds: 3));

    try {
      final dataState = await _checkAuthUseCase.execute();
      if (dataState is DataSuccess && dataState.data == true) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else {
        emit(state.copyWith(status: FormzSubmissionStatus.initial));
      }
    } catch (error) {
      emit(state.copyWith(status: FormzSubmissionStatus.initial));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final dataState = await _register.call(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );

      if (dataState is DataSuccess) {
        await _storageTokenUseCase.execute(dataState.data!.accessToken);
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else if (dataState is DataFailed) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
