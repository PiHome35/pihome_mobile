import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/chat/domain/entities/message.dart';
import 'package:mobile_pihome/features/chat/domain/repositories/chat_repository.dart';

class GetChatMessagesParams {
  final String chatId;
  final String token;
  final int? limit;
  final int? offset;
  final String? lastMessageId;

  const GetChatMessagesParams({
    required this.chatId,
    required this.token,
    this.limit,
    this.offset,
    this.lastMessageId,
  });
}

@injectable
class GetChatMessagesUseCase
    implements
        UseCase<GraphqlDataState<List<MessageEntity>>, GetChatMessagesParams> {
  final IChatRepository _repository;
  GetChatMessagesUseCase(this._repository);

  @override
  Future<GraphqlDataState<List<MessageEntity>>> execute(
      GetChatMessagesParams params) {
    return _repository.getChatMessages(
      chatId: params.chatId,
      token: params.token,
      limit: params.limit,
      offset: params.offset,
    );
  }
}
