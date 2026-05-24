import '../../domain/entities/chat_metrics_entity.dart';
import '../../domain/entities/source_entity.dart';

/// One parsed frame of the `/chat` SSE stream.
///
/// The backend emits exactly one [ChatMetaEvent] first, then a run of
/// [ChatTokenEvent]s, then a terminal [ChatDoneEvent] — or a [ChatErrorEvent]
/// at any point if generation fails.
sealed class ChatStreamEvent {
  const ChatStreamEvent();
}

/// Routing decision + (cultural path) the sources, known before any tokens.
class ChatMetaEvent extends ChatStreamEvent {
  const ChatMetaEvent({
    required this.route,
    required this.routerScore,
    required this.sources,
  });

  /// `'cultural'` (RAG, sourced) or `'direct'` (bare LLM, unsourced).
  final String route;
  final double routerScore;
  final List<Source> sources;
}

/// An incremental text fragment to append to the answer.
class ChatTokenEvent extends ChatStreamEvent {
  const ChatTokenEvent(this.delta);
  final String delta;
}

/// Terminal event carrying the metrics computed on the full answer.
class ChatDoneEvent extends ChatStreamEvent {
  const ChatDoneEvent(this.metrics);
  final ChatMetrics? metrics;
}

/// Server-side failure mid-stream.
class ChatErrorEvent extends ChatStreamEvent {
  const ChatErrorEvent(this.detail);
  final String detail;
}
