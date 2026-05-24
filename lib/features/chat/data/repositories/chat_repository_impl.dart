import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_metrics_entity.dart';
import '../../domain/entities/source_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/chat_remote_data_source.dart';
import '../datasources/chat_stream_event.dart';
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
  Stream<ChatStreamEvent> streamMessage(String chatId, String text) async* {
    if (!await networkInfo.isConnected) {
      throw const NetworkFailure(
        message: 'Pas de connexion. Vérifiez votre réseau et le serveur Cultini.',
      );
    }

    // Accumulate the answer as it streams so we can persist the turn on success.
    final buffer = StringBuffer();
    List<Source>? sources;
    ChatMetrics? metrics;
    var errored = false;

    await for (final event in remote.streamMessage(chatId, text)) {
      switch (event) {
        case ChatMetaEvent():
          sources = event.sources;
        case ChatTokenEvent():
          buffer.write(event.delta);
        case ChatDoneEvent():
          metrics = event.metrics;
        case ChatErrorEvent():
          errored = true;
      }
      yield event;
    }

    if (errored || buffer.isEmpty) return; // don't cache partial/failed turns.

    final now = DateTime.now();
    final userMsg = ChatMessageModel(
      id: 'u_${now.microsecondsSinceEpoch}',
      text: text,
      isUser: true,
      timestamp: now,
    );
    final aiMsg = ChatMessageModel(
      id: 'ai_${now.microsecondsSinceEpoch}',
      text: buffer.toString(),
      isUser: false,
      timestamp: now,
      sources: sources,
      metrics: metrics,
    );
    final history = <ChatMessageModel>[
      ...await local.getCachedHistory(),
      userMsg,
      aiMsg,
    ];
    await local.cacheHistory(history);
  }
}
