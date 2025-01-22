import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/features/setting/data/models/setting_model.dart';

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

  SettingModel toModel() {
    return SettingModel(
      userEmail: userEmail,
      selectedLLMModel: selectedLLMModel,
      isSpotifyConnected: isSpotifyConnected,
      familyName: familyName,
    );
  }

  SettingEntity copyWith({
    String? userEmail,
    String? selectedLLMModel,
    bool? isSpotifyConnected,
    String? familyName,
  }) {
    return SettingEntity(
      userEmail: userEmail ?? this.userEmail,
      selectedLLMModel: selectedLLMModel ?? this.selectedLLMModel,
      isSpotifyConnected: isSpotifyConnected ?? this.isSpotifyConnected,
      familyName: familyName ?? this.familyName,
    );
  }

  @override
  List<Object?> get props => [
        userEmail,
        selectedLLMModel,
        isSpotifyConnected,
        familyName,
      ];
}
