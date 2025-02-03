import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/chat/domain/repositories/chat_repository.dart';

class DeleteChatParams {
  final String chatId;
  final String token;

  DeleteChatParams({
    required this.chatId,
    required this.token,
  });
}

@injectable
class DeleteChatUseCase
    implements UseCase<GraphqlDataState<String>, DeleteChatParams> {
  final IChatRepository _repository;

  DeleteChatUseCase(this._repository);

  @override
  Future<GraphqlDataState<String>> execute(DeleteChatParams params) {
    return _repository.deleteChat(
      chatId: params.chatId,
      token: params.token,
    );
  }
}
