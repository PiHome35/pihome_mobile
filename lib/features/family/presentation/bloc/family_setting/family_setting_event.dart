sealed class FamilySettingEvent {
  const FamilySettingEvent();
}

final class FamilySettingPressed extends FamilySettingEvent {
  const FamilySettingPressed();
}

final class FamilyInviteCodePressed extends FamilySettingEvent {
  const FamilyInviteCodePressed();
}

final class FamilyDeleteInviteCodePressed extends FamilySettingEvent {
  const FamilyDeleteInviteCodePressed();
}

final class FetchFamilySettingDetail extends FamilySettingEvent {
  const FetchFamilySettingDetail();
}
