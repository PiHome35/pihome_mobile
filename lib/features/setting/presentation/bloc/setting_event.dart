import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';

sealed class SettingEvent {
  const SettingEvent();
}

class GetSettingEvent extends SettingEvent {
  const GetSettingEvent();
}

class UpdateSettingEvent extends SettingEvent {
  final SettingEntity setting;
  const UpdateSettingEvent(this.setting);
}
