import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/domain/repositories/setting_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateSettingUseCase implements UseCase<SettingEntity, SettingEntity> {
  final SettingRepository _repository;

  UpdateSettingUseCase(this._repository);

  @override
  Future<SettingEntity> execute(SettingEntity params) async {
    return await _repository.updateSetting(params);
  }
}
