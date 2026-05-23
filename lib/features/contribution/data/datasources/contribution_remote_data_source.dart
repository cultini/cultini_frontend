import '../../../../core/constants/end_points.dart';
import '../../../../core/network/api_client.dart';
import '../../../docs/domain/entities/doc_entry_entity.dart'; // DocCategoryX.apiValue
import '../models/contribution_model.dart';
import '../models/contribution_result_model.dart';

abstract class ContributionRemoteDataSource {
  /// POST {aiBaseUrl}/contributions → auto-filter verdict + moderation status.
  Future<ContributionResultModel> submit(ContributionModel contribution);
}

class ContributionRemoteDataSourceImpl implements ContributionRemoteDataSource {
  ContributionRemoteDataSourceImpl({required this.apiClient});

  /// The AI-backend ApiClient instance (points at [EndPoints.aiBaseUrl]).
  final ApiClient apiClient;

  @override
  Future<ContributionResultModel> submit(ContributionModel contribution) async {
    final response = await apiClient.post(
      EndPoints.contributions,
      body: {
        'titre': contribution.titre,
        'categorie': contribution.categorie.apiValue,
        // The backend corpus keys this as `region`; the form collects a wilaya.
        'region': contribution.wilaya,
        'contenu': contribution.contenu,
        'source': contribution.source,
        'contributor_name': contribution.contributorName,
      },
    );
    return ContributionResultModel.fromJson((response as Map).cast<String, dynamic>());
  }
}
