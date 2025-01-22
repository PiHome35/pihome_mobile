import 'package:mobile_pihome/core/domain/entities/user.dart';
import 'package:mobile_pihome/features/family/domain/entities/family_entity.dart';
import 'package:mobile_pihome/features/setting/data/models/spotify_connection_model.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/domain/entities/spotify_connection_entity.dart';

sealed class LoadingRemoteState {
  const LoadingRemoteState();
}

final class LoadingRemoteInitial extends LoadingRemoteState {
  const LoadingRemoteInitial();
}

final class LoadingRemoteLoading extends LoadingRemoteState {
  const LoadingRemoteLoading();
}

final class LoadingRemoteSpotifySuccess extends LoadingRemoteState {
  final SpotifyConnectionEntity spotifyConnection;
  const LoadingRemoteSpotifySuccess(this.spotifyConnection);
}

final class LoadingRemoteUserSuccess extends LoadingRemoteState {
  final UserEntity user;
  const LoadingRemoteUserSuccess(this.user);
}

final class LoadingRemoteFamilySuccess extends LoadingRemoteState {
  final FamilyEntity family;
  const LoadingRemoteFamilySuccess(this.family);
}

final class LoadingRemoteError extends LoadingRemoteState {
  final String message;
  const LoadingRemoteError(this.message);
}

final class LoadingRemoteSpotifyNotFound extends LoadingRemoteState {
  const LoadingRemoteSpotifyNotFound();
}

final class LoadingRemoteFamilyNotFound extends LoadingRemoteState {
  const LoadingRemoteFamilyNotFound();
}

final class LoadingRemoteSettingSuccess extends LoadingRemoteState {
  final SettingEntity setting;
  const LoadingRemoteSettingSuccess(this.setting);
}
