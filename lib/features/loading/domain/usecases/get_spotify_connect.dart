import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/setting/domain/entities/spotify_connection_entity.dart';
import 'package:mobile_pihome/features/setting/domain/repositories/setting_repository.dart';

class GetSpotifyConnectParams {

  final String accessToken;
  GetSpotifyConnectParams({required this.accessToken});
}

@injectable
class GetSpotifyConnectUseCase
    implements UseCase<DataState<SpotifyConnectionEntity?>, GetSpotifyConnectParams> {
  final SettingRepository _settingRepository;
  GetSpotifyConnectUseCase(this._settingRepository);

  @override
  Future<DataState<SpotifyConnectionEntity?>> execute(GetSpotifyConnectParams params) async {
    return await _settingRepository.getSpotifyConnection(
      accessToken: params.accessToken,
    );
  }
}