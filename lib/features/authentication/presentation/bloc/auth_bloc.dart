import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/validations/confirm_password.dart';
import 'package:mobile_pihome/core/validations/email.dart';
import 'package:mobile_pihome/core/validations/name.dart';
import 'package:mobile_pihome/core/validations/password.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/check_auth.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/get_storage_token.dart';
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
  final GetStorageTokenUseCase _getStorageTokenUseCase;
  final RegisterUseCase _register;

  AuthBloc(
    this._loginUseCase,
    this._checkAuthUseCase,
    this._storageTokenUseCase,
    this._register,
    this._getStorageTokenUseCase,
  ) : super(const AuthState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<NameChanged>(_onNameChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<CheckAuth>(_onCheckAuth);
    on<RegisterRequested>(_onRegisterRequested);
  }
  
  void _onEmailChanged(
    EmailChanged event,
    Emitter<AuthState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: _validateFields(email: email),
      ),
    );
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    final password = Password.dirty(event.password);
    final confirmPassword = state.confirmPassword.value.isEmpty
        ? state.confirmPassword
        : ConfirmPassword.dirty(
            password: event.password,
            value: state.confirmPassword.value,
          );

    emit(
      state.copyWith(
        password: password,
        confirmPassword: confirmPassword,
        isValid: _validateFields(password: password),
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
        isValid: _validateFields(confirmPassword: confirmPassword),
      ),
    );
  }

  void _onNameChanged(
    NameChanged event,
    Emitter<AuthState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        isValid: _validateFields(fullName: name),
      ),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    log('onLoginSubmitted');
    log('state is valid: ${state.isValid}');
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final accessToken = await _getStorageTokenUseCase.execute();
    try {
      final dataState = await _loginUseCase.execute(
        LoginParams(
          email: state.email.value,
          password: state.password.value,
          accessToken: accessToken,
        ),
      );
      log('dataState [login]: $dataState');

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
      log('dataState [checkAuth]: $dataState');
      if (dataState is DataSuccess && dataState.data == true) {
        log('dataState [checkAuth] success');
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else {
        log('dataState [checkAuth] failed');
        emit(state.copyWith(status: FormzSubmissionStatus.initial));
      }
    } catch (error) {
      log('error [checkAuth]: $error');
      emit(state.copyWith(status: FormzSubmissionStatus.initial));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final dataState = await _register.execute(
        RegisterParams(
          email: event.email,
          password: event.password,
          name: event.name,
        ),
      );
      

      if (dataState is DataSuccess) {
        log('[register] dataState: ${dataState.data!.accessToken}');
        await _storageTokenUseCase.execute(dataState.data!.accessToken);
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else if (dataState is DataFailed) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  bool _validateFields({
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    Name? fullName,
  }) {
    final emailToValidate = email ?? state.email;
    final passwordToValidate = password ?? state.password;
    final confirmPasswordToValidate = confirmPassword ?? state.confirmPassword;
    final fullNameToValidate = fullName ?? state.name;

    if (confirmPasswordToValidate.value.isEmpty) {
      return Formz.validate([
        emailToValidate,
        passwordToValidate,
      ]);
    }

    return Formz.validate([
      emailToValidate,
      passwordToValidate,
      confirmPasswordToValidate,
      fullNameToValidate,
    ]);
  }
}
