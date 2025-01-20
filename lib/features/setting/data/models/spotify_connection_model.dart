import 'package:mobile_pihome/features/setting/domain/entities/spotify_connection_entity.dart';

class SpotifyConnectionModel extends SpotifyConnectionEntity {
  const SpotifyConnectionModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresIn,
    required super.spotifyDeviceId,
    required super.familyId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SpotifyConnectionModel.fromJson(Map<String, dynamic> json) {
    return SpotifyConnectionModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'],
      spotifyDeviceId: json['spotifyDeviceId'],
      familyId: json['familyId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'spotifyDeviceId': spotifyDeviceId,
      'familyId': familyId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory SpotifyConnectionModel.fromEntity(SpotifyConnectionEntity entity) {
    return SpotifyConnectionModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      expiresIn: entity.expiresIn,
      spotifyDeviceId: entity.spotifyDeviceId,
      familyId: entity.familyId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  SpotifyConnectionEntity toEntity() {
    return SpotifyConnectionEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
      spotifyDeviceId: spotifyDeviceId,
      familyId: familyId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
