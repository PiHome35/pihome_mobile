import 'package:mobile_pihome/core/data/models/user_model.dart';
import 'package:mobile_pihome/features/setting/data/models/spotify_connection_model.dart';

abstract class SettingRemoteDataSource {
  Future<UserModel> getMe();
  Future<SpotifyConnectionModel> createSpotifyConnection();
  Future<SpotifyConnectionModel> getSpotifyConnection();
  Future<SpotifyConnectionModel> deleteSpotifyConnection();
}
