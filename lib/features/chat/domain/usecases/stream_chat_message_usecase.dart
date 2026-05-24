import '../../data/datasources/chat_stream_event.dart';
import '../repositories/chat_repository.dart';

class StreamChatMessageUseCase {
  const StreamChatMessageUseCase(this.repository);
  final ChatRepository repository;

  Stream<ChatStreamEvent> call(String chatId, String text) =>
      repository.streamMessage(chatId, text);
}
