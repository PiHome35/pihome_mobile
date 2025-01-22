import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/domain/repositories/setting_repository.dart';

class UpdateCacheSettingUseCase implements UseCase<void, SettingEntity> {
  final SettingRepository _settingRepository;

  UpdateCacheSettingUseCase(this._settingRepository);

  @override
  Future<void> execute(SettingEntity params) async {
    await _settingRepository.updateCachedSetting(params);
  }
}
