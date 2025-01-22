import 'package:mobile_pihome/core/domain/entities/user.dart';
import 'package:mobile_pihome/features/family/domain/entities/family_entity.dart';
import 'package:equatable/equatable.dart';

sealed class FamilySettingState extends Equatable {
  final List<UserEntity>? users;
  final FamilyEntity? family;
  const FamilySettingState({
    this.users,
    this.family,
  });

  @override
  List<Object?> get props => [users, family];
}

class FamilySettingStateInitial extends FamilySettingState {
  const FamilySettingStateInitial({
    super.users,
    super.family,
  });
}

class FamilyInviteCodeStateSuccess extends FamilySettingState {
  const FamilyInviteCodeStateSuccess({
    super.users,
    super.family,
    this.inviteCode,
  });
  final String? inviteCode;

  @override
  List<Object?> get props => [...super.props, inviteCode];
}

class FamilyInviteCodeStateFailure extends FamilySettingState {
  const FamilyInviteCodeStateFailure({
    super.users,
    super.family,
    this.errorMessage,
  });
  final String? errorMessage;

  @override
  List<Object?> get props => [...super.props, errorMessage];
}

class FamilyInviteCodeStateLoading extends FamilySettingState {
  const FamilyInviteCodeStateLoading({
    super.users,
    super.family,
  });
}

class FamilyDeleteInviteCodeStateSuccess extends FamilySettingState {
  const FamilyDeleteInviteCodeStateSuccess({
    super.users,
    super.family,
  });
}

class FamilySettingStateLoading extends FamilySettingState {
  const FamilySettingStateLoading({
    super.users,
    super.family,
  });
}

class FamilySettingStateFailure extends FamilySettingState {
  const FamilySettingStateFailure({
    super.users,
    super.family,
    this.errorMessage,
  });
  final String? errorMessage;

  @override
  List<Object?> get props => [...super.props, errorMessage];
}

class FamilySettingStateSuccess extends FamilySettingState {
  const FamilySettingStateSuccess({
    super.users,
    super.family,
  });
}
