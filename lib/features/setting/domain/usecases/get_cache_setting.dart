import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/domain/repositories/setting_repository.dart';

@injectable
class GetCachedSettingUseCase implements UseCase<SettingEntity, NoParams> {
  final SettingRepository _settingRepository;

  GetCachedSettingUseCase(this._settingRepository);

  @override
  Future<SettingEntity> execute(NoParams params) async {
    final setting = await _settingRepository.getCachedSetting();  
    return setting;
  }

}