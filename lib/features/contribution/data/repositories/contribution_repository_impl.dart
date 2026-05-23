import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/contribution_entity.dart';
import '../../domain/entities/contribution_result_entity.dart';
import '../../domain/repositories/contribution_repository.dart';
import '../datasources/contribution_local_data_source.dart';
import '../datasources/contribution_remote_data_source.dart';
import '../models/contribution_model.dart';

class ContributionRepositoryImpl implements ContributionRepository {
  ContributionRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  final ContributionRemoteDataSource remote;
  final ContributionLocalDataSource local;
  final NetworkInfo networkInfo;

  @override
  Future<ContributionResultEntity> submit(ContributionEntity contribution) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkFailure(
        message: 'Pas de connexion. Vérifiez votre réseau et le serveur Azetta.',
      );
    }
    final model = ContributionModel.fromEntity(contribution);
    final result = await remote.submit(model);
    // Keep a local copy of what the user sent (their own history), best-effort.
    if (result.accepted) {
      try {
        await local.save(model);
      } catch (_) {/* caching is non-critical */}
    }
    return result;
  }
}
