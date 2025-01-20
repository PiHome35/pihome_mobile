import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/get_storage_token.dart';
import 'package:mobile_pihome/features/chat/domain/entities/message.dart';
import 'package:mobile_pihome/features/chat/domain/usecases/add_message_usecase.dart';
import 'package:mobile_pihome/features/chat/domain/usecases/create_new_chat.dart';
import 'package:mobile_pihome/features/chat/domain/usecases/get_all_chats_usecase.dart';
import 'package:mobile_pihome/features/chat/domain/usecases/get_chat_messages_usecase.dart';
import 'package:mobile_pihome/features/chat/domain/usecases/subscribe_to_messages.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetStorageTokenUseCase _getStorageTokenUseCase;
  final GetAllChatsUseCase _getAllChatsUseCase;
  final GetChatMessagesUseCase _getChatMessagesUseCase;
  final AddMessageUseCase _addMessageUseCase;
  final CreateNewChatUseCase _createNewChatUseCase;
  final SubscribeToMessagesUseCase _subscribeToMessagesUseCase;

  StreamSubscription<GraphqlDataState<MessageEntity?>>? _messageSubscription;
  StreamSubscription? _chatSubscription;

  ChatBloc(
    this._getStorageTokenUseCase,
    this._getAllChatsUseCase,
    this._getChatMessagesUseCase,
    this._addMessageUseCase,
    this._subscribeToMessagesUseCase,
    this._createNewChatUseCase,
  ) : super(const ChatInitial()) {
    on<GetAllChats>(_onGetAllChats);
    on<GetChatMessages>(_onGetChatMessages);
    on<SendMessage>(_onSendMessage);
    on<StartMessageSubscription>(_onStartMessageSubscription);
    on<StartChatSubscription>(_onStartChatSubscription);
    on<StopMessageSubscription>(_onStopMessageSubscription);
    on<StopChatSubscription>(_onStopChatSubscription);
    on<NewMessageReceived>(_onNewMessageReceived);
    on<CreateNewChat>(_onCreateNewChat);
    on<CreatedNewChat>(_onCreatedNewChat);
  }

  Future<void> _onGetAllChats(
      GetAllChats event, Emitter<ChatState> emit) async {
    emit(const ChatLoading());
    final token = await _getStorageTokenUseCase.execute();
    if (token.isEmpty) {
      emit(const ChatError('No token found'));
      return;
    }
    final result = await _getAllChatsUseCase.execute(
      GetAllChatsParams(
        familyId: event.familyId,
        token: token,
        limit: event.limit,
        offset: event.offset,
      ),
    );
    if (result.data != null) {
      emit(ChatsLoaded(result.data!));
    } else {
      emit(ChatError(result.error.toString()));
    }
  }

  Future<void> _onGetChatMessages(
      GetChatMessages event, Emitter<ChatState> emit) async {
    emit(const ChatLoading());
    final token = await _getStorageTokenUseCase.execute();
    if (token.isEmpty) {
      emit(const ChatError('No token found'));
      return;
    }
    final result = await _getChatMessagesUseCase.execute(
      GetChatMessagesParams(
        chatId: event.chatId,
        token: token,
        limit: event.limit,
        offset: event.offset,
      ),
    );
    if (result.data != null) {
      emit(MessagesLoaded(result.data!));
    } else {
      emit(ChatError(result.error.toString()));
    }
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    final token = await _getStorageTokenUseCase.execute();
    if (token.isEmpty) {
      emit(const ChatError('No token found'));
      return;
    }

    final currentState = state;
    if (currentState is MessagesLoaded) {
      final currentMessages = List<MessageEntity>.from(currentState.messages);

      final result = await _addMessageUseCase.execute(
        AddMessageParams(
          content: event.content,
          senderId: event.senderId,
          chatId: event.chatId,
          token: token,
        ),
      );
      log('onsend message result: ${result.data?.content}');

      if (result.data != null) {
        currentMessages.add(result.data!);
        emit(MessagesLoaded(currentMessages));
      } else {
        emit(ChatError(result.error.toString()));
      }
    }
  }

  Future<void> _onStartMessageSubscription(
      StartMessageSubscription event, Emitter<ChatState> emit) async {
    await _messageSubscription?.cancel();

    final token = await _getStorageTokenUseCase.execute();
    if (token.isEmpty) {
      if (!emit.isDone) emit(const ChatError('No token found'));
      return;
    }

    try {
      final initialMessages = await _getChatMessagesUseCase.execute(
        GetChatMessagesParams(
          chatId: event.chatId,
          token: token,
        ),
      );

      List<MessageEntity> messages = [];
      if (initialMessages.data != null) {
        messages = List.from(initialMessages.data!);
        messages = messages.reversed.toList();
        emit(MessagesLoaded(messages));
      }

      _messageSubscription = _subscribeToMessagesUseCase
          .execute(
        SubscribeToMessagesParams(
          chatId: event.chatId,
          token: token,
        ),
      )
          .listen(
        (result) {
          log('Subscription result: ${result.data}');
          if (result.data != null) {
            log('new message received: ${result.data}');
            add(NewMessageReceived(result.data!));
          }
        },
        onError: (error) {
          emit(ChatError(error.toString()));
        },
      );
    } catch (e) {
      log('Subscription setup error: $e');
      if (!emit.isDone) {
        emit(ChatError(e.toString()));
      }
    }
  }

  Future<void> _onNewMessageReceived(
      NewMessageReceived event, Emitter<ChatState> emit) async {
    final currentState = state;
    if (currentState is MessagesLoaded) {
      final updatedMessages = List<MessageEntity>.from(currentState.messages);
      updatedMessages.add(event.message);
      emit(MessagesLoaded(updatedMessages));
    }
  }

  Future<void> _onCreateNewChat(
      CreateNewChat event, Emitter<ChatState> emit) async {
    final token = await _getStorageTokenUseCase.execute();
    if (token.isEmpty) {
      emit(const ChatError('No token found'));
      return;
    }
    final result = await _createNewChatUseCase.execute(
      CreateNewChatParams(
        familyId: event.familyId,
        token: token,
      ),
    );
    log('Chat created: ${result.data}');
    if (result.data != null) {
      emit(ChatCreated(result.data!));
    } else {
      emit(ChatError(result.error.toString()));
    }
  }

  Future<void> _onCreatedNewChat(CreatedNewChat event, Emitter<ChatState> emit) async {
    final currentState = state;
    log('after created new chat currentState: $currentState');
    if (currentState is ChatCreated) {
      add(GetAllChats(familyId: currentState.chat.familyId, limit: 25));
    }
  }

  Future<void> _onStartChatSubscription(
      StartChatSubscription event, Emitter<ChatState> emit) async {
    await _chatSubscription?.cancel();
  }

  Future<void> _onStopMessageSubscription(
      StopMessageSubscription event, Emitter<ChatState> emit) async {
    await _messageSubscription?.cancel();
    _messageSubscription = null;
  }

  Future<void> _onStopChatSubscription(
      StopChatSubscription event, Emitter<ChatState> emit) async {
    await _chatSubscription?.cancel();
    _chatSubscription = null;
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _chatSubscription?.cancel();
    return super.close();
  }
}
