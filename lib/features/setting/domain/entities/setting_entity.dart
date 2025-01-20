import 'package:equatable/equatable.dart';

class SettingEntity extends Equatable {
  final String userEmail;
  final String selectedLLMModel;
  final bool isSpotifyConnected;
  final String? familyName;

  const SettingEntity({
    required this.userEmail,
    required this.selectedLLMModel,
    required this.isSpotifyConnected,
    this.familyName,
  });

  @override
  List<Object?> get props =>
      [userEmail, selectedLLMModel, isSpotifyConnected, familyName];
}
