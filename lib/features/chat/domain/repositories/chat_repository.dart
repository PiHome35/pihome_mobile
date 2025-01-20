import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import '../entities/chat.dart';
import '../entities/message.dart';

abstract class IChatRepository {
  Future<GraphqlDataState<List<ChatEntity>>> getAllChatsWithFamilyId({
    required String familyId,
    required String token,
    int? limit,
    int? offset,
  });
  Future<GraphqlDataState<List<MessageEntity>>> getChatMessages({
    required String chatId,
    required String token,
    int? limit,
    int? offset,
  });
  Future<GraphqlDataState<ChatEntity>> createNewChat({
    required String familyId,
    required String token,
  });
  Future<GraphqlDataState<MessageEntity>> addMessage({
    required String content,
    required String senderId,
    required String chatId,
    required String token,
  });


  Stream<GraphqlDataState<MessageEntity?>> onMessageAdded({
    required String chatId,
    required String token,
  });
  Stream<GraphqlDataState<ChatEntity>> onChatCreated({
    required String token,
  });
}
