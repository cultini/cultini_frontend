import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_message_entity.dart';

class ChatState extends Equatable {
  const ChatState({
    required this.chatId,
    this.messages = const <ChatMessageEntity>[],
    this.isLoading = false,
    this.error,
  });

  /// Backend-managed conversation id (generated client-side, passed through).
  final String chatId;
  final List<ChatMessageEntity> messages;
  final bool isLoading;
  final String? error;

  ChatState copyWith({
    List<ChatMessageEntity>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      chatId: chatId,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [chatId, messages, isLoading, error];
}
