import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';

sealed class SettingState {
  const SettingState();
}

class SettingInitial extends SettingState {
  const SettingInitial();
}

class SettingLoading extends SettingState {
  const SettingLoading();
}

class SettingLoaded extends SettingState {
  final SettingEntity setting;
  const SettingLoaded(this.setting);
}

class SettingError extends SettingState {
  final String message;
  const SettingError(this.message);
}
