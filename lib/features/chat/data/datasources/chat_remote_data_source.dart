import '../../../../core/constants/end_points.dart';
import '../../../../core/network/api_client.dart';
import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  /// POST {aiBaseUrl}/chat  { chat_id, question } → AI message + sources + metrics.
  Future<ChatMessageModel> sendMessage(String chatId, String question);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl({required this.apiClient});

  /// The AI-backend ApiClient instance (points at [EndPoints.aiBaseUrl]).
  final ApiClient apiClient;

  @override
  Future<ChatMessageModel> sendMessage(String chatId, String question) async {
    final response = await apiClient.post(
      EndPoints.chat,
      body: {'chat_id': chatId, 'question': question},
    );
    return ChatMessageModel.fromChatResponse(
      (response as Map).cast<String, dynamic>(),
    );
  }
}
