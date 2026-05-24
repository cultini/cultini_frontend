import 'dart:convert';

import '../../../../core/constants/end_points.dart';
import '../../../../core/network/api_client.dart';
import '../models/chat_metrics_model.dart';
import '../models/source_model.dart';
import 'chat_stream_event.dart';

abstract class ChatRemoteDataSource {
  /// POST {aiBaseUrl}/chat  { chat_id, question } → SSE stream of
  /// meta / token / done events (see [ChatStreamEvent]).
  Stream<ChatStreamEvent> streamMessage(String chatId, String question);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl({required this.apiClient});

  /// The AI-backend ApiClient instance (points at [EndPoints.aiBaseUrl]).
  final ApiClient apiClient;

  @override
  Stream<ChatStreamEvent> streamMessage(String chatId, String question) async* {
    final lines = await apiClient.postStream(
      EndPoints.chat,
      body: {'chat_id': chatId, 'question': question},
    );
    await for (final line in lines) {
      if (!line.startsWith('data:')) continue; // skip blank / keepalive lines
      final payload = line.substring(5).trim();
      if (payload.isEmpty) continue;
      final json = jsonDecode(payload) as Map<String, dynamic>;
      switch (json['type'] as String?) {
        case 'meta':
          yield ChatMetaEvent(
            route: json['route'] as String? ?? 'cultural',
            routerScore: (json['router_score'] as num?)?.toDouble() ?? 0,
            sources: (json['source_nodes'] as List<dynamic>? ?? const [])
                .map((e) => SourceModel.fromJson((e as Map).cast<String, dynamic>()))
                .toList(),
          );
        case 'token':
          yield ChatTokenEvent(json['delta'] as String? ?? '');
        case 'done':
          final m = (json['metrics'] as Map?)?.cast<String, dynamic>();
          yield ChatDoneEvent(m == null ? null : ChatMetricsModel.fromJson(m));
        case 'error':
          yield ChatErrorEvent(json['detail'] as String? ?? 'Erreur du serveur.');
      }
    }
  }
}
