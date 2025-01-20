import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/domain/repositories/setting_repository.dart';

@injectable
class GetSettingUseCase implements UseCase<SettingEntity, void> {
  final SettingRepository _repository;
  GetSettingUseCase(this._repository);

  @override
  Future<SettingEntity> execute(void params) async {
    return await _repository.getSetting();
  }

}
