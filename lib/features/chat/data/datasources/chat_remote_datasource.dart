import 'dart:developer';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile_pihome/core/graphql/graphql_config.dart';
import 'package:mobile_pihome/features/chat/data/models/chat_model.dart';
import '../models/message_model.dart';

abstract class IChatRemoteDataSource {
  Future<List<ChatModel>> getAllChatsWithFamilyId({
    required String familyId,
    required String token,
    int? limit,
    int? offset,
  });
  Future<List<MessageModel>> getChatMessages({
    required String chatId,
    required String token,
    int? limit,
    int? offset,
  });
  Future<ChatModel> createNewChat({
    required String familyId,
    required String token,
  });
  Future<MessageModel> addMessage({
    required String content,
    required String senderId,
    required String chatId,
    required String token,
  });
  
  
  Stream<MessageModel?> onMessageAdded({
    required String chatId,
    required String token,
  });
  Stream<ChatModel> onChatCreated({
    required String token,
  });
  Future<bool> countdown({
    required int seconds,
  });
  Stream<int> onCountdown({
    required int seconds,
    // required String token,
  });
}

class ChatRemoteDataSource implements IChatRemoteDataSource {
  final GraphQLConfig _graphQLConfig;

  ChatRemoteDataSource(this._graphQLConfig);

  @override
  Future<List<ChatModel>> getAllChatsWithFamilyId({
    required String familyId,
    required String token,
    int? limit,
    int? offset,
  }) async {
    final result = await _graphQLConfig.clientWithToken(token).query(
          QueryOptions(
            fetchPolicy: FetchPolicy.networkOnly,
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
            document: gql('''
          query GetAllChatsWithFamilyId(\$familyId: String!, \$pagination: PaginationDto) {
            getAllChatsWithFamilyId(familyId: \$familyId, pagination: \$pagination) {
              id
              familyId
              name
              latestMessage {
                id
                content
                chatId
                senderId
                createdAt
              }
              createdAt
              updatedAt
            }
          }
        '''),
            variables: {
              'familyId': familyId,
              if (limit != null && offset != null)
                'pagination': {'limit': limit, 'offset': offset},
            },
          ),
        );
    log('result in getAllChatsWithFamilyId: ${result.data}');

    if (result.hasException) {
      log('error in getAllChatsWithFamilyId: ${result.exception}');
      throw result.exception!;
    }

    final List<dynamic> chats = result.data!['getAllChatsWithFamilyId'];
    return chats.map((chat) => ChatModel.fromJson(chat)).toList();
  }

  @override
  Future<List<MessageModel>> getChatMessages({
    required String chatId,
    required String token,
    int? limit,
    int? offset,
  }) async {
    final result = await _graphQLConfig.clientWithToken(token).query(
          QueryOptions(
            fetchPolicy: FetchPolicy.networkOnly,
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
            document: gql('''
          query GetChatMessages(\$chatId: String!, \$pagination: PaginationDto) {
            getChatMessages(chatId: \$chatId, pagination: \$pagination) {
              id
              content
              chatId
              senderId
              createdAt
            }
          }
        '''),
            variables: {
              'chatId': chatId,
              if (limit != null && offset != null)
                'pagination': {'limit': limit, 'skip': offset},
            },
          ),
        );

    if (result.hasException) {
      log('error in getChatMessages: ${result.exception}');
      throw result.exception!;
    }

    final List<dynamic> messages = result.data!['getChatMessages'];
    return messages.map((message) => MessageModel.fromJson(message)).toList();
  }

  @override
  Future<ChatModel> createNewChat({
    required String familyId,
    required String token,
  }) async {
    final result = await _graphQLConfig.clientWithToken(token).mutate(
          MutationOptions(
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
            fetchPolicy: FetchPolicy.networkOnly,
            document: gql('''
          mutation CreateNewChat(\$familyId: String!) {
            createNewChat(familyId: \$familyId) {
              id
              familyId
              name
              latestMessage {
                id
                content
                chatId
                senderId
                createdAt
              }
              createdAt
              updatedAt
            }
          }
        '''),
            variables: {'familyId': familyId},
          ),
        );

    log('result in createNewChat: ${result.data}');
    if (result.hasException) {
      log('error in createNewChat: ${result.exception}');
      throw result.exception!;
    }

    return ChatModel.fromJson(result.data!['createNewChat']);
  }

  @override
  Future<MessageModel> addMessage({
    required String content,
    required String senderId,
    required String chatId,
    required String token,
  }) async {
    final result = await _graphQLConfig.clientWithToken(token).mutate(
          MutationOptions(
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
            fetchPolicy: FetchPolicy.networkOnly,
            document: gql('''
          mutation AddMessage(\$content: String!, \$chatId: String!) {
            addMessage(content: \$content, chatId: \$chatId) {
              id
              content
              chatId
              senderId
              createdAt
            }
          }
        '''),
            variables: {
              'content': content,
              'chatId': chatId,
            },
          ),
        );

    if (result.hasException) {
      throw result.exception!;
    }
    return MessageModel.fromJson(result.data!['addMessage']);
  }

  @override
  Stream<MessageModel?> onMessageAdded({
    required String chatId,
    required String token,
  }) {
    log('Starting message subscription for chatId: $chatId');
    final operation = _graphQLConfig.clientWithToken(token).subscribe(
          SubscriptionOptions(
            document: gql('''
          subscription OnMessageAdded(\$chatId: String!) {
            messageAdded(chatId: \$chatId) {
              id
              content
              chatId
              senderId
              createdAt
            }
          }
        '''),
            variables: {'chatId': chatId},
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        );

    return operation.map((result) {
      if (result.hasException) {
        log('Subscription error: ${result.exception}');
        throw result.exception!;
      }

      final data = result.data?['messageAdded'];
      log('Received message data: $data');

      if (data == null) {
        return null;
      }

      return MessageModel.fromJson(data);
    }).handleError((error) {
      log('Error in message subscription: $error');
      throw error;
    });
  }

  @override
  Stream<ChatModel> onChatCreated({
    required String token,
  }) {
    final operation = _graphQLConfig.clientWithToken(token).subscribe(
          SubscriptionOptions(
            document: gql('''
          subscription OnChatCreated {
            chatCreated {
              id
              familyId
              name
              latestMessage {
                id
                content
                chatId
                senderId
                createdAt
              }
              createdAt
              updatedAt
            }
          }
        '''),
          ),
        );

    return operation.map((result) {
      if (result.hasException) {
        throw result.exception!;
      }
      return ChatModel.fromJson(result.data!['chatCreated']);
    });
  }

  
  @override
  Stream<int> onCountdown({required int seconds}) {
    final operation = _graphQLConfig.client.subscribe(
          SubscriptionOptions(
            document: gql('''
          subscription OnCountdown {
            countdown
          }
        '''),
            variables: {'seconds': seconds},
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        );

    return operation.map((result) {
      if (result.hasException) {
        throw result.exception!;
      }
      return result.data!['countdown'];
    });
  }
  
  @override
  Future<bool> countdown({required int seconds}) async {
    final result = await _graphQLConfig.client.mutate(
          MutationOptions(
            document: gql('''
          mutation Countdown(\$seconds: Float!) {
            startCountdown(seconds: \$seconds)
          }
        '''),
            variables: {'seconds': seconds},
            fetchPolicy: FetchPolicy.networkOnly,
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
          ),
        );

    if (result.hasException) {
      log('error in countdown: ${result.exception}');
      throw result.exception!;
    }
    return result.data!['countdown'];
  }
}

