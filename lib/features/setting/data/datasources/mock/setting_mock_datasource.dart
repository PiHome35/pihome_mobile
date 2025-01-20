import 'package:mobile_pihome/features/setting/data/models/setting_model.dart';
import 'package:injectable/injectable.dart';

abstract class SettingMockDatasource {
  Future<SettingModel> getSetting();
  Future<SettingModel> updateSetting(SettingModel setting);
}

@Environment('mock')
@LazySingleton(as: SettingMockDatasource)
class SettingMockDataSourceImpl implements SettingMockDatasource {
  final _mockSetting = SettingModel(
    userEmail: 'user@example.com',
    selectedLLMModel: 'GPT-4',
    isSpotifyConnected: false,
    familyName: 'Smith Family',
  );

  @override
  Future<SettingModel> getSetting() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockSetting;
  }

  @override
  Future<SettingModel> updateSetting(SettingModel setting) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newSetting = SettingModel(
      userEmail: setting.userEmail,
      selectedLLMModel: setting.selectedLLMModel,
      isSpotifyConnected: true,
      familyName: setting.familyName,
    );
    return newSetting;
  }
}
