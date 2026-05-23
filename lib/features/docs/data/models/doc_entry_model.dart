import '../../domain/entities/doc_entry_entity.dart';

class DocEntryModel extends DocEntryEntity {
  const DocEntryModel({
    required super.id,
    required super.titre,
    required super.contenu,
    required super.region,
    required super.categorie,
    required super.termesAmazighs,
    required super.source,
    super.fiabilite,
  });

  factory DocEntryModel.fromJson(Map<String, dynamic> json) => DocEntryModel(
        id: json['id'] as String? ?? '',
        titre: json['titre'] as String? ?? '',
        contenu: json['contenu'] as String? ?? '',
        region: json['region'] as String? ?? '',
        categorie: DocCategoryX.fromApi(json['categorie'] as String?),
        termesAmazighs: (json['termes_amazighs'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(),
        source: json['source'] as String? ?? '',
        fiabilite: json['fiabilite'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'titre': titre,
        'contenu': contenu,
        'region': region,
        'categorie': categorie.apiValue,
        'termes_amazighs': termesAmazighs,
        'source': source,
        'fiabilite': fiabilite,
      };
}
