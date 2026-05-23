import 'package:equatable/equatable.dart';

import 'chat_metrics_entity.dart';
import 'source_entity.dart';

class ChatMessageEntity extends Equatable {
  const ChatMessageEntity({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.sources,
    this.metrics,
  });

  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  /// Sources + metrics are only present on AI (assistant) messages.
  final List<Source>? sources;
  final ChatMetrics? metrics;

  @override
  List<Object?> get props => [id, text, isUser, timestamp, sources, metrics];
}
