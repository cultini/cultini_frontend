import '../../../docs/domain/entities/doc_entry_entity.dart';
import '../../domain/entities/contribution_entity.dart';

class ContributionModel extends ContributionEntity {
  const ContributionModel({
    required super.titre,
    required super.categorie,
    required super.wilaya,
    required super.contenu,
    required super.source,
    super.contributorName,
  });

  factory ContributionModel.fromEntity(ContributionEntity e) => ContributionModel(
        titre: e.titre,
        categorie: e.categorie,
        wilaya: e.wilaya,
        contenu: e.contenu,
        source: e.source,
        contributorName: e.contributorName,
      );

  factory ContributionModel.fromJson(Map<String, dynamic> json) =>
      ContributionModel(
        titre: json['titre'] as String? ?? '',
        categorie: DocCategoryX.fromApi(json['categorie'] as String?),
        wilaya: json['wilaya'] as String? ?? '',
        contenu: json['contenu'] as String? ?? '',
        source: json['source'] as String? ?? '',
        contributorName: json['contributor_name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'titre': titre,
        'categorie': categorie.apiValue,
        'wilaya': wilaya,
        'contenu': contenu,
        'source': source,
        'contributor_name': contributorName,
      };
}
