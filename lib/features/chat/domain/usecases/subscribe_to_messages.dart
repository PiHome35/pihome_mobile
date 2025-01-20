import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/chat/domain/entities/message.dart';
import 'package:mobile_pihome/features/chat/domain/repositories/chat_repository.dart';

class SubscribeToMessagesParams {
  final String chatId;
  final String token;

  SubscribeToMessagesParams({required this.chatId, required this.token});
}

@injectable
class SubscribeToMessagesUseCase extends StreamUseCase<GraphqlDataState<MessageEntity?>, SubscribeToMessagesParams> {
  final IChatRepository _chatRepository;

  SubscribeToMessagesUseCase(this._chatRepository);

  @override
  Stream<GraphqlDataState<MessageEntity?>> execute(
      SubscribeToMessagesParams params) {
    
    return _chatRepository.onMessageAdded(
      chatId: params.chatId,
      token: params.token,
    );
  }
}