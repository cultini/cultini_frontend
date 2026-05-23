import 'package:equatable/equatable.dart';

/// Anti-lissage metrics attached to each AI answer. Mirrors the backend's
/// `metrics` object: `cultural_coverage.percent`, `distinct_1`, `distinct_2`.
class ChatMetrics extends Equatable {
  const ChatMetrics({
    required this.culturalCoveragePercent,
    required this.distinct1,
    required this.distinct2,
    this.matchedTerms = const [],
  });

  /// Cultural-coverage percentage (0–100).
  final double culturalCoveragePercent;

  /// Lexical diversity (distinct unigram / bigram ratios, 0–1).
  final double distinct1;
  final double distinct2;

  /// Referential terms matched in the answer.
  final List<String> matchedTerms;

  @override
  List<Object?> get props =>
      [culturalCoveragePercent, distinct1, distinct2, matchedTerms];
}
