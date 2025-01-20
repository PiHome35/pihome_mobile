import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/chat/domain/entities/chat.dart';
import 'package:mobile_pihome/features/chat/domain/repositories/chat_repository.dart';

class CreateNewChatParams {
  final String familyId;
  final String token;

  CreateNewChatParams({required this.familyId, required this.token});
}

@injectable
class CreateNewChatUseCase
    implements UseCase<GraphqlDataState<ChatEntity>, CreateNewChatParams> {
  final IChatRepository _chatRepository;

  CreateNewChatUseCase(this._chatRepository);

  @override
  Future<GraphqlDataState<ChatEntity>> execute(
      CreateNewChatParams params) async {
    return _chatRepository.createNewChat(
      familyId: params.familyId,
      token: params.token,
    );
  }
}
