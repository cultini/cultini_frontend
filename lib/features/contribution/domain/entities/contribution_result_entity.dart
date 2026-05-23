import 'package:equatable/equatable.dart';

/// Outcome of submitting a contribution to the AI backend's auto-filter.
///
/// [accepted] is true when the submission cleared the filter and entered the
/// moderation queue (`status == 'pending'`); false when it was auto-rejected
/// (spam / doublon). [message] is the backend's user-facing French explanation.
class ContributionResultEntity extends Equatable {
  const ContributionResultEntity({
    required this.accepted,
    required this.status,
    required this.message,
  });

  final bool accepted;
  final String status; // 'pending' | 'auto_rejected'
  final String message;

  @override
  List<Object?> get props => [accepted, status, message];
}
