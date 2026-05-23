import '../entities/contribution_entity.dart';
import '../repositories/contribution_repository.dart';

class SubmitContributionUseCase {
  const SubmitContributionUseCase(this.repository);
  final ContributionRepository repository;

  Future<void> call(ContributionEntity contribution) =>
      repository.submit(contribution);
}
