import 'package:equatable/equatable.dart';

class SpotifyConnectionEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String spotifyDeviceId;
  final String familyId;
  final String createdAt;
  final String updatedAt;

  const SpotifyConnectionEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.spotifyDeviceId,
    required this.familyId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        expiresIn,
        spotifyDeviceId,
        familyId,
        createdAt,
        updatedAt,
      ];
}
