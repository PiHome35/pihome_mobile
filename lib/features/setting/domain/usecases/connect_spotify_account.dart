import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/setting/domain/repositories/setting_repository.dart';

@injectable
class ConnectSpotifyAccountUseCase implements UseCase<Map<String, dynamic>?, void> {
  final SettingRepository _settingRepository;

  ConnectSpotifyAccountUseCase(this._settingRepository);

  @override
  Future<Map<String, dynamic>?> execute(void params) async {
    return await _settingRepository.connectSpotifyAccount();
  }
}

