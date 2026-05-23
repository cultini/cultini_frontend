import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  final ChatRemoteDataSource remote;
  final ChatLocalDataSource local;
  final NetworkInfo networkInfo;

  @override
  Future<List<ChatMessageEntity>> getHistory() async {
    try {
      return await local.getCachedHistory();
    } catch (_) {
      return const <ChatMessageEntity>[];
    }
  }

  @override
  Future<ChatMessageEntity> sendMessage(String chatId, String text) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkFailure(
        message: 'Pas de connexion. Vérifiez votre réseau et le serveur Azetta.',
      );
    }
    final reply = await remote.sendMessage(chatId, text);
    final userMsg = ChatMessageModel(
      id: 'u_${DateTime.now().microsecondsSinceEpoch}',
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    final history = <ChatMessageModel>[
      ...await local.getCachedHistory(),
      userMsg,
      reply,
    ];
    await local.cacheHistory(history);
    return reply;
  }
}
