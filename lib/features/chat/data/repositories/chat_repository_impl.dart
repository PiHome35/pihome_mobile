import 'dart:async';
import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/graphql/graph_exception.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mobile_pihome/features/chat/domain/entities/chat.dart';
import 'package:mobile_pihome/features/chat/domain/entities/message.dart';
import 'package:mobile_pihome/features/chat/domain/repositories/chat_repository.dart';

@Injectable(as: IChatRepository)
class ChatRepositoryImpl implements IChatRepository {
  final IChatRemoteDataSource _remoteDataSource;
  // final StreamController<GraphqlDataState<MessageEntity>> _messageController =
  //     StreamController<GraphqlDataState<MessageEntity>>.broadcast();

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<GraphqlDataState<List<ChatEntity>>> getAllChatsWithFamilyId({
    required String familyId,
    required String token,
    int? limit,
    int? offset,
  }) async {
    try {
      final chats = await _remoteDataSource.getAllChatsWithFamilyId(
        familyId: familyId,
        token: token,
        limit: limit,
        offset: offset,
      );
      return GraphqlDataSuccess(chats.map((chat) => chat.toEntity()).toList());
    } catch (e) {
      if (e is GraphQLException) {
        return GraphqlDataFailed(e);
      }
      return GraphqlDataFailed(
        GraphQLException(
          message: 'Failed to load chats',
          type: e.toString().contains('UNAUTHENTICATED')
              ? GraphQLErrorType.auth
              : GraphQLErrorType.unknown,
        ),
      );
    }
  }

  @override
  Future<GraphqlDataState<List<MessageEntity>>> getChatMessages({
    required String chatId,
    required String token,
    int? limit,
    int? offset,
  }) async {
    try {
      final messages = await _remoteDataSource.getChatMessages(
        chatId: chatId,
        token: token,
        limit: limit,
        offset: offset,
      );
      return GraphqlDataSuccess(messages.map((msg) => msg.toEntity()).toList());
    } catch (e) {
      if (e is GraphQLException) {
        return GraphqlDataFailed(e);
      }
      return GraphqlDataFailed(
        GraphQLException(
          message: 'Failed to load messages',
          type: e.toString().contains('UNAUTHENTICATED')
              ? GraphQLErrorType.auth
              : GraphQLErrorType.unknown,
        ),
      );
    }
  }

  @override
  Future<GraphqlDataState<ChatEntity>> createNewChat({
    required String familyId,
    required String token,
  }) async {
    try {
      final chat = await _remoteDataSource.createNewChat(
        familyId: familyId,
        token: token,
      );
      return GraphqlDataSuccess(chat.toEntity());
    } catch (e) {
      if (e is GraphQLException) {
        return GraphqlDataFailed(e);
      }
      return GraphqlDataFailed(
        GraphQLException(
          message: 'Failed to create chat',
          type: e.toString().contains('UNAUTHENTICATED')
              ? GraphQLErrorType.auth
              : GraphQLErrorType.unknown,
        ),
      );
    }
  }

  @override
  Future<GraphqlDataState<MessageEntity>> addMessage({
    required String content,
    required String senderId,
    required String chatId,
    required String token,
  }) async {
    try {
      final message = await _remoteDataSource.addMessage(
        content: content,
        senderId: senderId,
        chatId: chatId,
        token: token,
      );
      return GraphqlDataSuccess(message.toEntity());
    } catch (e) {
      if (e is GraphQLException) {
        return GraphqlDataFailed(e);
      }
      return GraphqlDataFailed(
        GraphQLException(
          message: 'Failed to send message',
          type: e.toString().contains('UNAUTHENTICATED')
              ? GraphQLErrorType.auth
              : GraphQLErrorType.unknown,
        ),
      );
    }
  }


  @override
  Stream<GraphqlDataState<MessageEntity?>> onMessageAdded({
    required String chatId,
    required String token,
  }) {
    try {
      return _remoteDataSource
          .onMessageAdded(chatId: chatId, token: token)
          .map((message) => GraphqlDataSuccess(message?.toEntity()));
    } catch (e) {
      return Stream.value(
        const GraphqlDataFailed(
          GraphQLException(
            message: 'Failed to subscribe to messages',
            type: GraphQLErrorType.subscription,
          ),
        ),
      );
    }
  }

  @override
  Stream<GraphqlDataState<ChatEntity>> onChatCreated({
    required String token,
  }) {
    try {
      return _remoteDataSource
          .onChatCreated(token: token)
          .map((chat) => GraphqlDataSuccess(chat.toEntity()))
          .handleError(
            (error) => const GraphqlDataFailed(
              GraphQLException(
                message: 'Failed to subscribe to chat updates',
                type: GraphQLErrorType.subscription,
              ),
            ),
          );
    } catch (e) {
      return Stream.value(
        const GraphqlDataFailed(
          GraphQLException(
            message: 'Failed to subscribe to chat updates',
            type: GraphQLErrorType.subscription,
          ),
        ),
      );
    }
  }
}
