import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:mobile_pihome/core/validations/family_name.dart';
import 'package:mobile_pihome/features/family/domain/entities/family_entity.dart';

final class FamilyState extends Equatable {
  const FamilyState({
    this.familyName = const FamilyName.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
    this.family,
    this.inviteCode,
  });

  final FamilyName familyName;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;
  final FamilyEntity? family;
  final String? inviteCode;

  FamilyState copyWith({
    FamilyName? familyName,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
    FamilyEntity? family,
    String? inviteCode,
  }) {
    return FamilyState(
      familyName: familyName ?? this.familyName,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      family: family ?? this.family,
      inviteCode: inviteCode ?? this.inviteCode,
    );
  }

  @override
  List<Object?> get props => [
        familyName,
        status,
        isValid,
        errorMessage,
        family,
        inviteCode,
      ];
}
