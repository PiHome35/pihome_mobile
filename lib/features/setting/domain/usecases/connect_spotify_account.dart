import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/services/spotify_auth_service.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';

@injectable
class ConnectSpotifyAccountUseCase implements UseCase<bool, void> {
  final SpotifyAuthService _spotifyAuthService;

  ConnectSpotifyAccountUseCase(this._spotifyAuthService);

  @override
  Future<bool> execute(void params) async {
    return await _spotifyAuthService.authenticate();
  }
}

