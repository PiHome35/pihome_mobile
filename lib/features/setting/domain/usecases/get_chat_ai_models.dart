import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/family/domain/entities/chat_ai_entity.dart';
import 'package:mobile_pihome/features/setting/domain/repositories/setting_repository.dart';

@injectable
class GetChatAiModelsUseCase implements UseCase<List<ChatAiModelEntity>, String> {
  final SettingRepository _settingRepository;

  GetChatAiModelsUseCase(this._settingRepository);

  @override
  Future<List<ChatAiModelEntity>> execute(String token) async {
    return _settingRepository.getChatAiModels(token: token);
  }
}
