import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/domain/entities/spotify_connection_entity.dart';

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
  // final SpotifyConnectionEntity spotifyConnection;
  const SettingLoaded(
    this.setting,
    // this.spotifyConnection,
  );
}


class SettingError extends SettingState {
  final String message;
  const SettingError(this.message);
}

class SpotifyConnectLoaded extends SettingState {
  final SpotifyConnectionEntity spotifyConnection;
  const SpotifyConnectLoaded(this.spotifyConnection);
}

class SpotifyConnectError extends SettingState {
  final String message;
  const SpotifyConnectError(this.message);
}

class SpotifyConnectLoading extends SettingState {
  const SpotifyConnectLoading();
}
