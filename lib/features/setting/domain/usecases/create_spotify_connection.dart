import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/setting/domain/entities/spotify_connection_entity.dart';
import 'package:mobile_pihome/features/setting/domain/repositories/setting_repository.dart';

class CreateSpotifyConnectionParams {
  final String accessToken;
  CreateSpotifyConnectionParams({
    required this.accessToken,
  });
}

@injectable
class CreateSpotifyConnectionUseCase
    implements
        UseCase<DataState<SpotifyConnectionEntity>,
            CreateSpotifyConnectionParams> {
  final SettingRepository _repository;
  CreateSpotifyConnectionUseCase(this._repository);

  @override
  Future<DataState<SpotifyConnectionEntity>> execute(
      CreateSpotifyConnectionParams params) async {
    return await _repository.createSpotifyConnection(
      accessToken: params.accessToken,
    );
  }
}
