import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';

abstract class SettingRepository {
  Future<SettingEntity> getSetting();
  Future<SettingEntity> updateSetting(SettingEntity setting);
}
