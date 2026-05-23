import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  /// Cached conversation (local only — the backend has no bulk-history call here).
  Future<List<ChatMessageEntity>> getHistory();

  /// Sends a question to the RAG backend and returns the AI answer (with its
  /// sources + metrics). [chatId] is the backend-managed conversation id.
  Future<ChatMessageEntity> sendMessage(String chatId, String text);
}
