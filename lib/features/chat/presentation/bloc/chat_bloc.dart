import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/get_chat_history_usecase.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required this.getHistory, required this.sendMessage})
      : super(ChatState(chatId: const Uuid().v4())) {
    on<ChatStarted>(_onStarted);
    on<ChatMessageSent>(_onMessageSent);
  }

  final GetChatHistoryUseCase getHistory;
  final SendChatMessageUseCase sendMessage;

  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    try {
      final history = await getHistory();
      emit(state.copyWith(messages: history));
    } catch (_) {
      // Cache miss is non-fatal — start with an empty conversation.
    }
  }

  Future<void> _onMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    final text = event.text.trim();
    if (text.isEmpty) return;

    final pending = ChatMessageEntity(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    emit(state.copyWith(
      messages: [...state.messages, pending],
      isLoading: true,
      error: null,
    ));

    try {
      final reply = await sendMessage(state.chatId, text);
      emit(state.copyWith(
        messages: [...state.messages, reply],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e is Failure ? e.message : e.toString(),
      ));
    }
  }
}
