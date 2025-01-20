import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';

part 'setting_model.g.dart';

@HiveType(typeId: 1)
class SettingModel {
  @HiveField(0)
  final String userEmail;

  @HiveField(1)
  final String selectedLLMModel;

  @HiveField(2)
  final bool isSpotifyConnected;

  @HiveField(3)
  final String? familyName;

  SettingModel({
    required this.userEmail,
    required this.selectedLLMModel,
    required this.isSpotifyConnected,
    this.familyName,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      userEmail: json['userEmail'] as String,
      selectedLLMModel: json['selectedLLMModel'] as String,
      isSpotifyConnected: json['isSpotifyConnected'] as bool,
      familyName: json['familyName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'selectedLLMModel': selectedLLMModel,
      'isSpotifyConnected': isSpotifyConnected,
      'familyName': familyName,
    };
  }

  factory SettingModel.fromEntity(SettingEntity entity) {
    return SettingModel(
      userEmail: entity.userEmail,
      selectedLLMModel: entity.selectedLLMModel,
      isSpotifyConnected: entity.isSpotifyConnected,
      familyName: entity.familyName,
    );
  }

  SettingEntity toEntity() => SettingEntity(
        userEmail: userEmail,
        selectedLLMModel: selectedLLMModel,
        isSpotifyConnected: isSpotifyConnected,
        familyName: familyName,
      );
}
