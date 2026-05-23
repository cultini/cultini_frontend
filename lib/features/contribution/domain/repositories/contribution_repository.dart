import '../entities/contribution_entity.dart';

abstract class ContributionRepository {
  /// Persists a contribution. The mock implementation stores it locally; a real
  /// implementation would POST it to the backend.
  Future<void> submit(ContributionEntity contribution);
}
