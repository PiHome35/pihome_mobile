import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/setting/data/datasources/mock/setting_mock_datasource.dart';
import 'package:mobile_pihome/features/setting/data/models/setting_model.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/domain/repositories/setting_repository.dart';

@LazySingleton(as: SettingRepository)
class SettingRepositoryImpl implements SettingRepository {
  final SettingMockDatasource _dataSource;

  SettingRepositoryImpl(this._dataSource);

  @override
  Future<SettingEntity> getSetting() async {
    try {
      final result = await _dataSource.getSetting();
      log('Setting: $result');
      return result.toEntity();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<SettingEntity> updateSetting(SettingEntity setting) async {
    try {
      final settingModel = SettingModel(
        userEmail: setting.userEmail,
        selectedLLMModel: 'gpt-5o',
        isSpotifyConnected: setting.isSpotifyConnected,
      );

      await _dataSource.updateSetting(settingModel);
      return setting;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
