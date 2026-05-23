import 'package:equatable/equatable.dart';

import '../../../docs/domain/entities/doc_entry_entity.dart';

/// A user-submitted documentation suggestion.
class ContributionEntity extends Equatable {
  const ContributionEntity({
    required this.titre,
    required this.categorie,
    required this.wilaya,
    required this.contenu,
    required this.source,
    this.contributorName,
  });

  final String titre;
  final DocCategory categorie;
  final String wilaya;
  final String contenu;
  final String source;
  final String? contributorName;

  @override
  List<Object?> get props =>
      [titre, categorie, wilaya, contenu, source, contributorName];
}
