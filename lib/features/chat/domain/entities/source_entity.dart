import 'package:equatable/equatable.dart';

/// A retrieved corpus source backing an AI answer (one `source_nodes[]` item
/// from the FastAPI `/chat` response). All fields are nullable on the backend.
class Source extends Equatable {
  const Source({
    this.titre,
    this.region,
    this.source,
    this.fiabilite,
    this.categorie,
    this.score,
  });

  final String? titre;
  final String? region;
  final String? source;
  final String? fiabilite;
  final String? categorie;
  final double? score;

  @override
  List<Object?> get props => [titre, region, source, fiabilite, categorie, score];
}
