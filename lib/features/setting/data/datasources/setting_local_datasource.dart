import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/constants/hive_constant.dart';
import 'package:mobile_pihome/core/utils/cache/hive_manager.dart';
import 'package:mobile_pihome/features/setting/data/models/setting_model.dart';

abstract class SettingLocalDataSource {
  Future<void> cachedSetting(SettingModel setting);
  Future<SettingModel?> getCachedSetting();
}

@LazySingleton(as: SettingLocalDataSource)
class SettingLocalDataSourceImpl implements SettingLocalDataSource {
  final HiveManager _hiveManager;

  SettingLocalDataSourceImpl(this._hiveManager);

  @override
  Future<void> cachedSetting(SettingModel setting) async {
    await _hiveManager.settingBox.put(HiveConstant.settingBoxKey, setting);
  }

  @override
  Future<SettingModel?> getCachedSetting() async {
    return _hiveManager.settingBox.get(HiveConstant.settingBoxKey);
  }
}
