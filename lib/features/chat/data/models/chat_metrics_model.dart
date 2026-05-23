import '../../domain/entities/chat_metrics_entity.dart';

class ChatMetricsModel extends ChatMetrics {
  const ChatMetricsModel({
    required super.culturalCoveragePercent,
    required super.distinct1,
    required super.distinct2,
    super.matchedTerms,
  });

  /// Parses the backend `metrics` object:
  /// `{ cultural_coverage: { percent, matched, total, matched_terms }, distinct_1, distinct_2 }`.
  factory ChatMetricsModel.fromJson(Map<String, dynamic> json) {
    final coverage =
        (json['cultural_coverage'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{};
    return ChatMetricsModel(
      culturalCoveragePercent: (coverage['percent'] as num?)?.toDouble() ?? 0,
      distinct1: (json['distinct_1'] as num?)?.toDouble() ?? 0,
      distinct2: (json['distinct_2'] as num?)?.toDouble() ?? 0,
      matchedTerms: (coverage['matched_terms'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'cultural_coverage': {
          'percent': culturalCoveragePercent,
          'matched_terms': matchedTerms,
        },
        'distinct_1': distinct1,
        'distinct_2': distinct2,
      };
}
