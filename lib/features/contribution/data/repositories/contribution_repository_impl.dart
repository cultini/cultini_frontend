import '../../domain/entities/contribution_entity.dart';
import '../../domain/repositories/contribution_repository.dart';
import '../datasources/contribution_local_data_source.dart';
import '../models/contribution_model.dart';

class ContributionRepositoryImpl implements ContributionRepository {
  ContributionRepositoryImpl({required this.local});
  final ContributionLocalDataSource local;

  @override
  Future<void> submit(ContributionEntity contribution) async {
    // Simulate a short network round-trip so the UI can show a loading state.
    await Future.delayed(const Duration(milliseconds: 600));
    await local.save(ContributionModel.fromEntity(contribution));
  }
}
