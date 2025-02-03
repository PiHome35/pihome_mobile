import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/family/domain/entities/chat_ai_entity.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/domain/entities/spotify_connection_entity.dart';

abstract class SettingRepository {
  Future<Map<String, dynamic>?> connectSpotifyAccount();
  Future<void> logoutSpotifyConnect();
  Future<DataState<SpotifyConnectionEntity>> createSpotifyConnection({
    required String accessToken,
  });
  Future<DataState<SpotifyConnectionEntity?>> getSpotifyConnection({
    required String accessToken,
  });
  Future<SettingEntity> getCachedSetting();
  Future<void> cacheSetting(SettingEntity setting);
  Future<SettingEntity> updateCachedSetting(SettingEntity setting);
  Future<List<ChatAiModelEntity>> getChatAiModels({required String token});
  // Future<SettingEntity> updateSetting(SettingEntity setting);
}
