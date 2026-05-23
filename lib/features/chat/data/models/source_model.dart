import '../../domain/entities/source_entity.dart';

class SourceModel extends Source {
  const SourceModel({
    super.titre,
    super.region,
    super.source,
    super.fiabilite,
    super.categorie,
    super.score,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) => SourceModel(
        titre: json['titre'] as String?,
        region: json['region'] as String?,
        source: json['source'] as String?,
        fiabilite: json['fiabilite'] as String?,
        categorie: json['categorie'] as String?,
        score: (json['score'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'titre': titre,
        'region': region,
        'source': source,
        'fiabilite': fiabilite,
        'categorie': categorie,
        'score': score,
      };
}
