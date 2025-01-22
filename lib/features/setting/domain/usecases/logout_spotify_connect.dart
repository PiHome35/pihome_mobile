import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/setting/domain/repositories/setting_repository.dart';

@injectable
class LogoutSpotifyConnectUseCase implements UseCase<void, void> {
  final SettingRepository _repository;
  LogoutSpotifyConnectUseCase(this._repository);

  @override
  Future<void> execute(void params) async {
    return await _repository.logoutSpotifyConnect();
  }
}
