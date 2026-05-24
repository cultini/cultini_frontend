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

  /// Returns a copy with the given fields replaced — used to grow a streaming
  /// AI message token by token and attach its sources / metrics as they arrive.
  ChatMessageEntity copyWith({
    String? text,
    List<Source>? sources,
    ChatMetrics? metrics,
  }) {
    return ChatMessageEntity(
      id: id,
      text: text ?? this.text,
      isUser: isUser,
      timestamp: timestamp,
      sources: sources ?? this.sources,
      metrics: metrics ?? this.metrics,
    );
  }

  @override
  List<Object?> get props => [id, text, isUser, timestamp, sources, metrics];
}
