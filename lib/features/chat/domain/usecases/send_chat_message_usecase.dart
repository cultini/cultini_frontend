import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class SendChatMessageUseCase {
  const SendChatMessageUseCase(this.repository);
  final ChatRepository repository;

  Future<ChatMessageEntity> call(String chatId, String text) =>
      repository.sendMessage(chatId, text);
}
