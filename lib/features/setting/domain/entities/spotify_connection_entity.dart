import 'package:equatable/equatable.dart';

class SpotifyConnectionEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String spotifyDeviceId;
  final String familyId;
  final String createdAt;
  final String updatedAt;

  const SpotifyConnectionEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.spotifyDeviceId,
    required this.familyId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        spotifyDeviceId,
        familyId,
        createdAt,
        updatedAt,
      ];
}
