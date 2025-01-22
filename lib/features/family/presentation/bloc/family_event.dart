sealed class FamilyEvent {
  const FamilyEvent();
}

final class FamilyNameChanged extends FamilyEvent {
  const FamilyNameChanged(this.name);
  final String name;
}

final class CreateFamilySubmitted extends FamilyEvent {
  const CreateFamilySubmitted();
}

final class JoinFamilySubmitted extends FamilyEvent {
  const JoinFamilySubmitted({required this.inviteCode});
  final String inviteCode;
}

