import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatHistoryUseCase {
  const GetChatHistoryUseCase(this.repository);
  final ChatRepository repository;

  Future<List<ChatMessageEntity>> call() => repository.getHistory();
}
