import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failure.dart';
import '../../data/datasources/chat_stream_event.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/get_chat_history_usecase.dart';
import '../../domain/usecases/stream_chat_message_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required this.getHistory, required this.streamMessage})
      : super(ChatState(chatId: const Uuid().v4())) {
    on<ChatStarted>(_onStarted);
    on<ChatMessageSent>(_onMessageSent);
  }

  final GetChatHistoryUseCase getHistory;
  final StreamChatMessageUseCase streamMessage;

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

    final userMsg = ChatMessageEntity(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    final aiId = 'ai_${DateTime.now().microsecondsSinceEpoch}';
    var aiMsg = ChatMessageEntity(
      id: aiId,
      text: '',
      isUser: false,
      timestamp: DateTime.now(),
    );

    emit(state.copyWith(
      messages: [...state.messages, userMsg, aiMsg],
      isLoading: true,
      error: null,
    ));

    // Replace the streaming AI placeholder (matched by id) in the live list.
    List<ChatMessageEntity> withUpdatedAi(ChatMessageEntity updated) => [
          for (final m in state.messages) if (m.id == aiId) updated else m,
        ];

    try {
      await for (final ev in streamMessage(state.chatId, text)) {
        switch (ev) {
          case ChatMetaEvent():
            aiMsg = aiMsg.copyWith(sources: ev.sources);
            emit(state.copyWith(messages: withUpdatedAi(aiMsg)));
          case ChatTokenEvent():
            aiMsg = aiMsg.copyWith(text: aiMsg.text + ev.delta);
            emit(state.copyWith(messages: withUpdatedAi(aiMsg)));
          case ChatDoneEvent():
            aiMsg = aiMsg.copyWith(metrics: ev.metrics);
            emit(state.copyWith(
              messages: withUpdatedAi(aiMsg),
              isLoading: false,
            ));
          case ChatErrorEvent():
            emit(state.copyWith(isLoading: false, error: ev.detail));
        }
      }
      // Stream ended without a `done` event (e.g. server hung up) — clear the
      // spinner if it's still up.
      if (state.isLoading) emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e is Failure ? e.message : e.toString(),
      ));
    }
  }
}
