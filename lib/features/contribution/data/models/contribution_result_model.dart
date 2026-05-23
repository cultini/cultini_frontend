import '../../domain/entities/contribution_result_entity.dart';

class ContributionResultModel extends ContributionResultEntity {
  const ContributionResultModel({
    required super.accepted,
    required super.status,
    required super.message,
  });

  /// Parses the `POST /contributions` response from the FastAPI backend.
  factory ContributionResultModel.fromJson(Map<String, dynamic> json) =>
      ContributionResultModel(
        accepted: json['accepted'] as bool? ?? false,
        status: json['status'] as String? ?? 'pending',
        message: json['message'] as String? ??
            'Votre contribution a été enregistrée.',
      );
}
