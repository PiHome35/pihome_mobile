import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/domain/repositories/setting_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CacheSettingUseCase implements UseCase<void, SettingEntity> {
  final SettingRepository _settingRepository;
  CacheSettingUseCase(this._settingRepository);

  @override
  Future<void> execute(SettingEntity params) async {
    await _settingRepository.cacheSetting(params);
  }
}