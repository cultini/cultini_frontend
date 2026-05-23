import '../../domain/entities/chat_message_entity.dart';
import 'chat_metrics_model.dart';
import 'source_model.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.text,
    required super.isUser,
    required super.timestamp,
    super.sources,
    super.metrics,
  });

  /// Builds the AI message from a FastAPI `/chat` response:
  /// `{ chat_id, response, source_nodes[], metrics, ... }`.
  factory ChatMessageModel.fromChatResponse(Map<String, dynamic> json) {
    final nodes = (json['source_nodes'] as List<dynamic>? ?? const [])
        .map((e) => SourceModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
    final metricsJson = (json['metrics'] as Map?)?.cast<String, dynamic>();
    return ChatMessageModel(
      id: 'ai_${DateTime.now().microsecondsSinceEpoch}',
      text: (json['response'] as String?)?.trim() ?? '',
      isUser: false,
      timestamp: DateTime.now(),
      sources: nodes,
      metrics: metricsJson == null ? null : ChatMetricsModel.fromJson(metricsJson),
    );
  }

  /// For local cache round-trips.
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final rawSources = json['sources'] as List<dynamic>?;
    final rawMetrics = (json['metrics'] as Map?)?.cast<String, dynamic>();
    return ChatMessageModel(
      id: json['id'] as String,
      text: json['text'] as String,
      isUser: json['is_user'] as bool? ?? false,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sources: rawSources
          ?.map((e) => SourceModel.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      metrics: rawMetrics == null ? null : ChatMetricsModel.fromJson(rawMetrics),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'is_user': isUser,
        'timestamp': timestamp.toIso8601String(),
        'sources': sources
            ?.map((s) => s is SourceModel
                ? s.toJson()
                : SourceModel(
                    titre: s.titre,
                    region: s.region,
                    source: s.source,
                    fiabilite: s.fiabilite,
                    categorie: s.categorie,
                    score: s.score,
                  ).toJson())
            .toList(),
        'metrics': metrics == null
            ? null
            : ChatMetricsModel(
                culturalCoveragePercent: metrics!.culturalCoveragePercent,
                distinct1: metrics!.distinct1,
                distinct2: metrics!.distinct2,
                matchedTerms: metrics!.matchedTerms,
              ).toJson(),
      };
}
