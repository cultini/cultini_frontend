import '../../data/datasources/chat_stream_event.dart';
import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  /// Cached conversation (local only — the backend has no bulk-history call here).
  Future<List<ChatMessageEntity>> getHistory();

  /// Streams the AI answer to a question as SSE events (meta / token / done).
  /// [chatId] is the backend-managed conversation id. The completed turn
  /// (question + assembled answer) is persisted to the local cache once the
  /// stream ends successfully.
  Stream<ChatStreamEvent> streamMessage(String chatId, String text);
}
