import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/chat/domain/entities/message.dart';
import 'package:mobile_pihome/features/chat/domain/repositories/chat_repository.dart';

class AddMessageParams {
  final String content;
  final String senderId;
  final String chatId;
  final String token;

  AddMessageParams({
    required this.content,
    required this.senderId,
    required this.chatId,
    required this.token,
  });
}

@injectable
class AddMessageUseCase
    implements UseCase<GraphqlDataState<MessageEntity>, AddMessageParams> {
  final IChatRepository _repository;

  AddMessageUseCase(this._repository);

  @override
  Future<GraphqlDataState<MessageEntity>> execute(AddMessageParams params) {
    return _repository.addMessage(
      content: params.content,
      senderId: params.senderId,
      chatId: params.chatId,
      token: params.token,
    );
  }
}
