import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/core/domain/entities/user.dart';

abstract class UserLocalState extends Equatable {
  const UserLocalState();

  @override
  List<Object?> get props => [];
}

class UserLocalInitial extends UserLocalState {
  const UserLocalInitial();
}

class UserLocalLoading extends UserLocalState {
  const UserLocalLoading();
}

class UserLocalLoaded extends UserLocalState {
  final UserEntity user;

  const UserLocalLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserLocalError extends UserLocalState {
  final String message;

  const UserLocalError(this.message);

  @override
  List<Object?> get props => [message];
}


