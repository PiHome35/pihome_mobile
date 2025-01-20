import 'package:mobile_pihome/core/domain/entities/user.dart';

sealed class LoadingRemoteState {
  const LoadingRemoteState();
}

final class LoadingRemoteInitial extends LoadingRemoteState {
  const LoadingRemoteInitial();
}

final class LoadingRemoteLoading extends LoadingRemoteState {
  const LoadingRemoteLoading();
}

final class LoadingRemoteSuccess extends LoadingRemoteState {
  final UserEntity user;
  const LoadingRemoteSuccess(this.user);
}

final class LoadingRemoteError extends LoadingRemoteState {
  final String message;
  const LoadingRemoteError(this.message);
}
