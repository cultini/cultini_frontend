import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/azetta_motif.dart';
import '../domain/entities/source_entity.dart';

/// Renders the corpus sources backing an AI answer.
class SourceList extends StatelessWidget {
  const SourceList({super.key, required this.sources});

  final List<Source> sources;

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_outlined,
                  size: 14, color: AppColors.indigo),
              const SizedBox(width: 6),
              Text(
                'Sources (${sources.length})',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: AppColors.indigo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const AzettaDivider(height: 12, opacity: 0.18, cell: 14),
          const SizedBox(height: 2),
          ...sources.map((s) => _SourceRow(source: s)),
        ],
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.source});
  final Source source;

  @override
  Widget build(BuildContext context) {
    final subtitleParts = [
      if (source.region != null && source.region!.isNotEmpty) source.region!,
      if (source.source != null && source.source!.isNotEmpty) source.source!,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(Icons.diamond_outlined, size: 9, color: AppColors.accent),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  source.titre?.isNotEmpty == true ? source.titre! : 'Source',
                  style: GoogleFonts.fraunces(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitleParts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      subtitleParts.join(' · '),
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 10.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (source.fiabilite != null && source.fiabilite!.isNotEmpty)
            _FiabiliteBadge(fiabilite: source.fiabilite!),
        ],
      ),
    );
  }
}

class _FiabiliteBadge extends StatelessWidget {
  const _FiabiliteBadge({required this.fiabilite});
  final String fiabilite;

  @override
  Widget build(BuildContext context) {
    // Each fiabilité value carries its own tone; unknown values fall back to a
    // neutral tone and show the raw label.
    final (Color color, String label) = switch (fiabilite) {
      'documentee' => (AppColors.fiabiliteDocumentee, 'documentée'),
      'partielle' => (AppColors.fiabilitePartielle, 'partielle'),
      'a_verifier' => (AppColors.fiabiliteAVerifier, 'à vérifier'),
      _ => (AppColors.textSecondary, fiabilite),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.hankenGrotesk(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
