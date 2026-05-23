import 'package:equatable/equatable.dart';

/// Documentation categories (mirrors the corpus `categorie` values).
enum DocCategory { motif, bijou, ecriture, technique, gastronomie, savoirFaire }

extension DocCategoryX on DocCategory {
  /// Backend/corpus token, e.g. `motif`, `savoir-faire`.
  String get apiValue {
    switch (this) {
      case DocCategory.savoirFaire:
        return 'savoir-faire';
      default:
        return name;
    }
  }

  /// Human label (French).
  String get label {
    switch (this) {
      case DocCategory.motif:
        return 'Motif';
      case DocCategory.bijou:
        return 'Bijou';
      case DocCategory.ecriture:
        return 'Écriture';
      case DocCategory.technique:
        return 'Technique';
      case DocCategory.gastronomie:
        return 'Gastronomie';
      case DocCategory.savoirFaire:
        return 'Savoir-faire';
    }
  }

  static DocCategory fromApi(String? value) {
    switch (value) {
      case 'bijou':
        return DocCategory.bijou;
      case 'ecriture':
        return DocCategory.ecriture;
      case 'technique':
        return DocCategory.technique;
      case 'gastronomie':
        return DocCategory.gastronomie;
      case 'savoir-faire':
        return DocCategory.savoirFaire;
      case 'motif':
      default:
        return DocCategory.motif;
    }
  }
}

class DocEntryEntity extends Equatable {
  const DocEntryEntity({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.region,
    required this.categorie,
    required this.termesAmazighs,
    required this.source,
    this.fiabilite,
  });

  final String id;
  final String titre;
  final String contenu;
  final String region;
  final DocCategory categorie;
  final List<String> termesAmazighs;
  final String source;
  final String? fiabilite;

  @override
  List<Object?> get props =>
      [id, titre, contenu, region, categorie, termesAmazighs, source, fiabilite];
}
