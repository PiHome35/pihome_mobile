import 'package:mobile_pihome/features/family/domain/entities/chat_ai_entity.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/domain/entities/spotify_connection_entity.dart';
import 'package:mobile_pihome/features/family/data/models/chat_ai_model.dart';

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
  final List<ChatAiModelEntity>? chatModels;
  final bool isModelUpdateSuccess;

  const SettingLoaded(
    this.setting, {
    this.chatModels,
    this.isModelUpdateSuccess = false,
  });

  @override
  List<Object?> get props => [setting, isModelUpdateSuccess];

  SettingLoaded copyWith({
    SettingEntity? setting,
    List<ChatAiModelEntity>? chatModels,
    bool? isModelUpdateSuccess,
  }) {
    return SettingLoaded(
      setting ?? this.setting,
      chatModels: chatModels ?? this.chatModels,
      isModelUpdateSuccess: isModelUpdateSuccess ?? this.isModelUpdateSuccess,
    );
  }
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
