import '../entities/contribution_entity.dart';
import '../entities/contribution_result_entity.dart';

abstract class ContributionRepository {
  /// POSTs a contribution to the AI backend's auto-filter and returns the
  /// moderation outcome (accepted into the queue, or auto-rejected).
  Future<ContributionResultEntity> submit(ContributionEntity contribution);
}
